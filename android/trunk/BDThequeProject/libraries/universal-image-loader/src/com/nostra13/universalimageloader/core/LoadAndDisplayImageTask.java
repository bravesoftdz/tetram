/*******************************************************************************
 * Copyright 2011-2013 Sergey Tarasevich
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/
package com.nostra13.universalimageloader.core;

import android.graphics.Bitmap;
import android.os.Handler;
import android.widget.ImageView;

import com.nostra13.universalimageloader.cache.disc.DiscCacheAware;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.assist.FailReason.FailType;
import com.nostra13.universalimageloader.core.assist.ImageLoadingListener;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.ImageSize;
import com.nostra13.universalimageloader.core.assist.LoadedFrom;
import com.nostra13.universalimageloader.core.assist.ViewScaleType;
import com.nostra13.universalimageloader.core.decode.ImageDecoder;
import com.nostra13.universalimageloader.core.decode.ImageDecodingInfo;
import com.nostra13.universalimageloader.core.download.ImageDownloader;
import com.nostra13.universalimageloader.core.download.ImageDownloader.Scheme;
import com.nostra13.universalimageloader.utils.IoUtils;
import com.nostra13.universalimageloader.utils.L;

import org.jetbrains.annotations.Nullable;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.Reference;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Presents load'n'display image task. Used to load image from Internet or file system, decode it to {@link Bitmap}, and
 * display it in {@link ImageView} using {@link DisplayBitmapTask}.
 *
 * @author Sergey Tarasevich (nostra13[at]gmail[dot]com)
 * @see ImageLoaderConfiguration
 * @see ImageLoadingInfo
 * @since 1.3.1
 */
@SuppressWarnings("ConstantNamingConvention")
final class LoadAndDisplayImageTask implements Runnable {

    private static final String LOG_WAITING_FOR_RESUME = "ImageLoader is paused. Waiting...  [%s]";
    private static final String LOG_RESUME_AFTER_PAUSE = ".. Resume loading [%s]";
    private static final String LOG_DELAY_BEFORE_LOADING = "Delay %d ms before loading...  [%s]";
    private static final String LOG_START_DISPLAY_IMAGE_TASK = "Start display image task [%s]";
    private static final String LOG_WAITING_FOR_IMAGE_LOADED = "Image already is loading. Waiting... [%s]";
    private static final String LOG_GET_IMAGE_FROM_MEMORY_CACHE_AFTER_WAITING = "...Get cached bitmap from memory after waiting. [%s]";
    private static final String LOG_LOAD_IMAGE_FROM_NETWORK = "Load image from network [%s]";
    private static final String LOG_LOAD_IMAGE_FROM_DISC_CACHE = "Load image from disc cache [%s]";
    private static final String LOG_PREPROCESS_IMAGE = "PreProcess image before caching in memory [%s]";
    private static final String LOG_POSTPROCESS_IMAGE = "PostProcess image before displaying [%s]";
    private static final String LOG_CACHE_IMAGE_IN_MEMORY = "Cache image in memory [%s]";
    private static final String LOG_CACHE_IMAGE_ON_DISC = "Cache image on disc [%s]";
    private static final String LOG_PROCESS_IMAGE_BEFORE_CACHE_ON_DISC = "Process image before cache on disc [%s]";
    private static final String LOG_TASK_CANCELLED_IMAGEVIEW_REUSED = "ImageView is reused for another image. Task is cancelled. [%s]";
    private static final String LOG_TASK_CANCELLED_IMAGEVIEW_LOST = "ImageView was collected by GC. Task is cancelled. [%s]";
    private static final String LOG_TASK_INTERRUPTED = "Task was interrupted [%s]";

    private static final String ERROR_PRE_PROCESSOR_NULL = "Pre-processor returned null [%s]";
    private static final String ERROR_POST_PROCESSOR_NULL = "Pre-processor returned null [%s]";
    private static final String ERROR_PROCESSOR_FOR_DISC_CACHE_NULL = "Bitmap processor for disc cache returned null [%s]";

    private static final int BUFFER_SIZE = 32 * 1024; // 32 Kb

    private final ImageLoaderEngine engine;
    private final ImageLoadingInfo imageLoadingInfo;
    private final Handler handler;

    // Helper references
    private final ImageLoaderConfiguration configuration;
    private final ImageDownloader downloader;
    private final ImageDownloader networkDeniedDownloader;
    private final ImageDownloader slowNetworkDownloader;
    private final ImageDecoder decoder;
    private final boolean writeLogs;
    final String uri;
    private final String memoryCacheKey;
    final Reference<ImageView> imageViewRef;
    private final ImageSize targetSize;
    final DisplayImageOptions options;
    final ImageLoadingListener listener;

    // State vars
    private LoadedFrom loadedFrom = LoadedFrom.NETWORK;
    private boolean imageViewCollected;

    public LoadAndDisplayImageTask(ImageLoaderEngine engine, ImageLoadingInfo imageLoadingInfo, Handler handler) {
        this.engine = engine;
        this.imageLoadingInfo = imageLoadingInfo;
        this.handler = handler;

        this.configuration = engine.configuration;
        this.downloader = this.configuration.downloader;
        this.networkDeniedDownloader = this.configuration.networkDeniedDownloader;
        this.slowNetworkDownloader = this.configuration.slowNetworkDownloader;
        this.decoder = this.configuration.decoder;
        this.writeLogs = this.configuration.writeLogs;
        this.uri = imageLoadingInfo.uri;
        this.memoryCacheKey = imageLoadingInfo.memoryCacheKey;
        this.imageViewRef = imageLoadingInfo.imageViewRef;
        this.targetSize = imageLoadingInfo.targetSize;
        this.options = imageLoadingInfo.options;
        this.listener = imageLoadingInfo.listener;
    }

    @SuppressWarnings("VariableNotUsedInsideIf")
    @Override
    public void run() {
        if (waitIfPaused()) return;
        if (delayIfNeed()) return;

        ReentrantLock loadFromUriLock = this.imageLoadingInfo.loadFromUriLock;
        log(LOG_START_DISPLAY_IMAGE_TASK);
        if (loadFromUriLock.isLocked()) {
            log(LOG_WAITING_FOR_IMAGE_LOADED);
        }

        loadFromUriLock.lock();
        Bitmap bmp;
        try {
            if (checkTaskIsNotActual()) return;

            bmp = this.configuration.memoryCache.get(this.memoryCacheKey);
            if (bmp == null) {
                bmp = tryLoadBitmap();
                if (this.imageViewCollected) return; // listener callback already was fired
                if (bmp == null) return; // listener callback already was fired

                if (checkTaskIsNotActual() || checkTaskIsInterrupted()) return;

                if (this.options.shouldPreProcess()) {
                    log(LOG_PREPROCESS_IMAGE);
                    bmp = this.options.getPreProcessor().process(bmp);
                    if (bmp == null) {
                        L.e(ERROR_PRE_PROCESSOR_NULL);
                    }
                }

                if ((bmp != null) && this.options.isCacheInMemory()) {
                    log(LOG_CACHE_IMAGE_IN_MEMORY);
                    this.configuration.memoryCache.put(this.memoryCacheKey, bmp);
                }
            } else {
                this.loadedFrom = LoadedFrom.MEMORY_CACHE;
                log(LOG_GET_IMAGE_FROM_MEMORY_CACHE_AFTER_WAITING);
            }

            if ((bmp != null) && this.options.shouldPostProcess()) {
                log(LOG_POSTPROCESS_IMAGE);
                bmp = this.options.getPostProcessor().process(bmp);
                if (bmp == null) {
                    L.e(ERROR_POST_PROCESSOR_NULL, this.memoryCacheKey);
                }
            }
        } finally {
            loadFromUriLock.unlock();
        }

        if (checkTaskIsNotActual() || checkTaskIsInterrupted()) return;

        DisplayBitmapTask displayBitmapTask = new DisplayBitmapTask(bmp, this.imageLoadingInfo, this.engine, this.loadedFrom);
        displayBitmapTask.setLoggingEnabled(this.writeLogs);
        this.handler.post(displayBitmapTask);
    }

    /**
     * @return true - if task should be interrupted; false - otherwise
     */
    @SuppressWarnings({"BooleanMethodNameMustStartWithQuestion", "SynchronizationOnLocalVariableOrMethodParameter"})
    private boolean waitIfPaused() {
        AtomicBoolean pause = this.engine.getPause();
        synchronized (pause) {
            if (pause.get()) {
                log(LOG_WAITING_FOR_RESUME);
                try {
                    pause.wait();
                } catch (InterruptedException e) {
                    L.e(LOG_TASK_INTERRUPTED, this.memoryCacheKey);
                    return true;
                }
                log(LOG_RESUME_AFTER_PAUSE);
            }
        }
        return checkTaskIsNotActual();
    }

    /**
     * @return true - if task should be interrupted; false - otherwise
     */
    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    private boolean delayIfNeed() {
        if (this.options.shouldDelayBeforeLoading()) {
            log(LOG_DELAY_BEFORE_LOADING, this.options.getDelayBeforeLoading(), this.memoryCacheKey);
            try {
                Thread.sleep(this.options.getDelayBeforeLoading());
            } catch (InterruptedException e) {
                L.e(LOG_TASK_INTERRUPTED, this.memoryCacheKey);
                return true;
            }
            return checkTaskIsNotActual();
        }
        return false;
    }

    /**
     * Check whether target ImageView wasn't collected by GC and the image URI of this task matches to image URI which is actual
     * for current ImageView at this moment and fire {@link ImageLoadingListener#onLoadingCancelled(String, android.view.View)}}
     * event if it doesn't.
     */
    private boolean checkTaskIsNotActual() {
        ImageView imageView = checkImageViewRef();
        return (imageView == null) || checkImageViewReused(imageView);
    }

    @SuppressWarnings({"NonBooleanMethodNameMayNotStartWithQuestion", "VariableNotUsedInsideIf"})
    private ImageView checkImageViewRef() {
        ImageView imageView = this.imageViewRef.get();
        if (imageView == null) {
            this.imageViewCollected = true;
            log(LOG_TASK_CANCELLED_IMAGEVIEW_LOST);
            fireCancelEvent();
        }
        return imageView;
    }

    private boolean checkImageViewReused(ImageView imageView) {
        String currentCacheKey = this.engine.getLoadingUriForView(imageView);
        // Check whether memory cache key (image URI) for current ImageView is actual.
        // If ImageView is reused for another task then current task should be cancelled.
        boolean imageViewWasReused = !this.memoryCacheKey.equals(currentCacheKey);
        if (imageViewWasReused) {
            log(LOG_TASK_CANCELLED_IMAGEVIEW_REUSED);
            fireCancelEvent();
        }
        return imageViewWasReused;
    }

    /**
     * Check whether the current task was interrupted
     */
    private boolean checkTaskIsInterrupted() {
        boolean interrupted = Thread.interrupted();
        if (interrupted) log(LOG_TASK_INTERRUPTED);
        return interrupted;
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    @Nullable
    private Bitmap tryLoadBitmap() {
        File imageFile = getImageFileInDiscCache();

        Bitmap bitmap = null;
        try {
            if (imageFile.exists()) {
                log(LOG_LOAD_IMAGE_FROM_DISC_CACHE);

                this.loadedFrom = LoadedFrom.DISC_CACHE;
                bitmap = decodeImage(Scheme.FILE.wrap(imageFile.getAbsolutePath()));
                if (this.imageViewCollected) return null;
            }
            if ((bitmap == null) || (bitmap.getWidth() <= 0) || (bitmap.getHeight() <= 0)) {
                log(LOG_LOAD_IMAGE_FROM_NETWORK);

                this.loadedFrom = LoadedFrom.NETWORK;
                String imageUriForDecoding = this.options.isCacheOnDisc() ? tryCacheImageOnDisc(imageFile) : this.uri;
                if (!checkTaskIsNotActual()) {
                    bitmap = decodeImage(imageUriForDecoding);
                    if (this.imageViewCollected) return null;
                    if ((bitmap == null) || (bitmap.getWidth() <= 0) || (bitmap.getHeight() <= 0)) {
                        fireFailEvent(FailType.DECODING_ERROR, null);
                    }
                }
            }
        } catch (IllegalStateException e) {
            fireFailEvent(FailType.NETWORK_DENIED, null);
        } catch (IOException e) {
            L.e(e);
            fireFailEvent(FailType.IO_ERROR, e);
            if (imageFile.exists()) {
                imageFile.delete();
            }
        } catch (OutOfMemoryError e) {
            L.e(e);
            fireFailEvent(FailType.OUT_OF_MEMORY, e);
        } catch (Throwable e) {
            L.e(e);
            fireFailEvent(FailType.UNKNOWN, e);
        }
        return bitmap;
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    private File getImageFileInDiscCache() {
        DiscCacheAware discCache = this.configuration.discCache;
        File imageFile = discCache.get(this.uri);
        File cacheDir = imageFile.getParentFile();
        if ((cacheDir == null) || (!cacheDir.exists() && !cacheDir.mkdirs())) {
            imageFile = this.configuration.reserveDiscCache.get(this.uri);
            cacheDir = imageFile.getParentFile();
            if ((cacheDir != null) && !cacheDir.exists()) {
                cacheDir.mkdirs();
            }
        }
        return imageFile;
    }

    @Nullable
    private Bitmap decodeImage(String imageUri) throws IOException {
        ImageView imageView = checkImageViewRef();
        if (imageView == null) return null;

        ViewScaleType viewScaleType = ViewScaleType.fromImageView(imageView);
        ImageDecodingInfo decodingInfo = new ImageDecodingInfo(this.memoryCacheKey, imageUri, this.targetSize, viewScaleType, getDownloader(), this.options);
        return this.decoder.decode(decodingInfo);
    }

    /**
     * @return Cached image URI; or original image URI if caching failed
     */
    private String tryCacheImageOnDisc(File targetFile) {
        log(LOG_CACHE_IMAGE_ON_DISC);

        try {
            int width = this.configuration.maxImageWidthForDiscCache;
            int height = this.configuration.maxImageHeightForDiscCache;
            boolean saved = false;
            if ((width > 0) || (height > 0)) {
                saved = downloadSizedImage(targetFile, width, height);
            }
            if (!saved) {
                downloadImage(targetFile);
            }

            this.configuration.discCache.put(this.uri, targetFile);
            return Scheme.FILE.wrap(targetFile.getAbsolutePath());
        } catch (IOException e) {
            L.e(e);
            return this.uri;
        }
    }

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    private boolean downloadSizedImage(File targetFile, int maxWidth, int maxHeight) throws IOException {
        // Download, decode, compress and save image
        ImageSize targetImageSize = new ImageSize(maxWidth, maxHeight);
        DisplayImageOptions specialOptions = new DisplayImageOptions.Builder().cloneFrom(this.options).imageScaleType(ImageScaleType.IN_SAMPLE_INT).build();
        ImageDecodingInfo decodingInfo = new ImageDecodingInfo(this.memoryCacheKey, this.uri, targetImageSize, ViewScaleType.FIT_INSIDE, getDownloader(), specialOptions);
        Bitmap bmp = this.decoder.decode(decodingInfo);
        if (bmp == null) return false;

        if (this.configuration.processorForDiscCache != null) {
            log(LOG_PROCESS_IMAGE_BEFORE_CACHE_ON_DISC);
            bmp = this.configuration.processorForDiscCache.process(bmp);
            if (bmp == null) {
                L.e(ERROR_PROCESSOR_FOR_DISC_CACHE_NULL, this.memoryCacheKey);
                return false;
            }
        }

        boolean savedSuccessfully;
        OutputStream os = new BufferedOutputStream(new FileOutputStream(targetFile), BUFFER_SIZE);
        try {
            savedSuccessfully = bmp.compress(this.configuration.imageCompressFormatForDiscCache, this.configuration.imageQualityForDiscCache, os);
        } finally {
            IoUtils.closeSilently(os);
        }
        bmp.recycle();
        return savedSuccessfully;
    }

    private void downloadImage(File targetFile) throws IOException {
        InputStream is = getDownloader().getStream(this.uri, this.options.getExtraForDownloader());
        try {
            OutputStream os = new BufferedOutputStream(new FileOutputStream(targetFile), BUFFER_SIZE);
            try {
                IoUtils.copyStream(is, os);
            } finally {
                IoUtils.closeSilently(os);
            }
        } finally {
            IoUtils.closeSilently(is);
        }
    }

    private void fireFailEvent(final FailType failType, final Throwable failCause) {
        if (!Thread.interrupted()) {
            this.handler.post(new Runnable() {
                @Override
                public void run() {
                    ImageView imageView = LoadAndDisplayImageTask.this.imageViewRef.get();
                    if ((imageView != null) && LoadAndDisplayImageTask.this.options.shouldShowImageOnFail()) {
                        imageView.setImageResource(LoadAndDisplayImageTask.this.options.getImageOnFail());
                    }
                    LoadAndDisplayImageTask.this.listener.onLoadingFailed(LoadAndDisplayImageTask.this.uri, imageView, new FailReason(failType, failCause));
                }
            });
        }
    }

    private void fireCancelEvent() {
        if (!Thread.interrupted()) {
            this.handler.post(new Runnable() {
                @Override
                public void run() {
                    LoadAndDisplayImageTask.this.listener.onLoadingCancelled(LoadAndDisplayImageTask.this.uri, LoadAndDisplayImageTask.this.imageViewRef.get());
                }
            });
        }
    }

    private ImageDownloader getDownloader() {
        ImageDownloader imageDownloader;
        if (this.engine.isNetworkDenied()) {
            imageDownloader = this.networkDeniedDownloader;
        } else if (this.engine.isSlowNetwork()) {
            imageDownloader = this.slowNetworkDownloader;
        } else {
            imageDownloader = this.downloader;
        }
        return imageDownloader;
    }

    String getLoadingUri() {
        return this.uri;
    }

    private void log(String message) {
        if (this.writeLogs) L.d(message, this.memoryCacheKey);
    }

    @SuppressWarnings("OverloadedVarargsMethod")
    private void log(String message, Object... args) {
        if (this.writeLogs) L.d(message, args);
    }
}
