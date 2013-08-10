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
import android.widget.ImageView;

import com.nostra13.universalimageloader.core.assist.ImageLoadingListener;
import com.nostra13.universalimageloader.core.assist.LoadedFrom;
import com.nostra13.universalimageloader.core.display.BitmapDisplayer;
import com.nostra13.universalimageloader.utils.L;

import java.lang.ref.Reference;

/**
 * Displays bitmap in {@link ImageView}. Must be called on UI thread.
 *
 * @author Sergey Tarasevich (nostra13[at]gmail[dot]com)
 * @see ImageLoadingListener
 * @see BitmapDisplayer
 * @since 1.3.1
 */
@SuppressWarnings("ConstantNamingConvention")
final class DisplayBitmapTask implements Runnable {

    private static final String LOG_DISPLAY_IMAGE_IN_IMAGEVIEW = "Display image in ImageView (loaded from %1$s) [%2$s]";
    private static final String LOG_TASK_CANCELLED_IMAGEVIEW_REUSED = "ImageView is reused for another image. Task is cancelled. [%s]";
    private static final String LOG_TASK_CANCELLED_IMAGEVIEW_LOST = "ImageView was collected by GC. Task is cancelled. [%s]";

    private final Bitmap bitmap;
    private final String imageUri;
    private final Reference<ImageView> imageViewRef;
    private final String memoryCacheKey;
    private final BitmapDisplayer displayer;
    private final ImageLoadingListener listener;
    private final ImageLoaderEngine engine;
    private final LoadedFrom loadedFrom;

    private boolean loggingEnabled;

    public DisplayBitmapTask(Bitmap bitmap, ImageLoadingInfo imageLoadingInfo, ImageLoaderEngine engine, LoadedFrom loadedFrom) {
        this.bitmap = bitmap;
        this.imageUri = imageLoadingInfo.uri;
        this.imageViewRef = imageLoadingInfo.imageViewRef;
        this.memoryCacheKey = imageLoadingInfo.memoryCacheKey;
        this.displayer = imageLoadingInfo.options.getDisplayer();
        this.listener = imageLoadingInfo.listener;
        this.engine = engine;
        this.loadedFrom = loadedFrom;
    }

    @Override
    public void run() {
        ImageView imageView = this.imageViewRef.get();
        if (imageView == null) {
            if (this.loggingEnabled) L.d(LOG_TASK_CANCELLED_IMAGEVIEW_LOST, this.memoryCacheKey);
            this.listener.onLoadingCancelled(this.imageUri, imageView);
        } else if (isViewWasReused(imageView)) {
            if (this.loggingEnabled) L.d(LOG_TASK_CANCELLED_IMAGEVIEW_REUSED, this.memoryCacheKey);
            this.listener.onLoadingCancelled(this.imageUri, imageView);
        } else {
            if (this.loggingEnabled)
                L.d(LOG_DISPLAY_IMAGE_IN_IMAGEVIEW, this.loadedFrom, this.memoryCacheKey);
            Bitmap displayedBitmap = this.displayer.display(this.bitmap, imageView, this.loadedFrom);
            this.listener.onLoadingComplete(this.imageUri, imageView, displayedBitmap);
            this.engine.cancelDisplayTaskFor(imageView);
        }
    }

    /**
     * Checks whether memory cache key (image URI) for current ImageView is actual
     */
    private boolean isViewWasReused(ImageView imageView) {
        String currentCacheKey = this.engine.getLoadingUriForView(imageView);
        return !this.memoryCacheKey.equals(currentCacheKey);
    }

    void setLoggingEnabled(boolean loggingEnabled) {
        this.loggingEnabled = loggingEnabled;
    }
}
