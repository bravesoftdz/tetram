/*******************************************************************************
 * Copyright 2013 Sergey Tarasevich
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
package com.nostra13.universalimageloader.core.decode;

import android.annotation.TargetApi;
import android.graphics.BitmapFactory.Options;
import android.os.Build;

import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.ImageSize;
import com.nostra13.universalimageloader.core.assist.MemoryCacheUtil;
import com.nostra13.universalimageloader.core.assist.ViewScaleType;
import com.nostra13.universalimageloader.core.download.ImageDownloader;

/**
 * Contains needed information for decoding image to Bitmap
 *
 * @author Sergey Tarasevich (nostra13[at]gmail[dot]com)
 * @since 1.8.3
 */
public class ImageDecodingInfo {

    private final String imageKey;
    private final String imageUri;
    private final ImageSize targetSize;

    private final ImageScaleType imageScaleType;
    private final ViewScaleType viewScaleType;

    private final ImageDownloader downloader;
    private final Object extraForDownloader;

    private final Options decodingOptions;

    public ImageDecodingInfo(String imageKey, String imageUri, ImageSize targetSize, ViewScaleType viewScaleType, ImageDownloader downloader, DisplayImageOptions displayOptions) {
        this.imageKey = imageKey;
        this.imageUri = imageUri;
        this.targetSize = targetSize;

        this.imageScaleType = displayOptions.getImageScaleType();
        this.viewScaleType = viewScaleType;

        this.downloader = downloader;
        this.extraForDownloader = displayOptions.getExtraForDownloader();

        this.decodingOptions = new Options();
        copyOptions(displayOptions.getDecodingOptions(), this.decodingOptions);
    }

    @TargetApi(Build.VERSION_CODES.DONUT)
    private static void copyOptions(Options srcOptions, Options destOptions) {
        destOptions.inDensity = srcOptions.inDensity;
        destOptions.inDither = srcOptions.inDither;
        destOptions.inInputShareable = srcOptions.inInputShareable;
        destOptions.inJustDecodeBounds = srcOptions.inJustDecodeBounds;
        destOptions.inPreferredConfig = srcOptions.inPreferredConfig;
        destOptions.inPurgeable = srcOptions.inPurgeable;
        destOptions.inSampleSize = srcOptions.inSampleSize;
        destOptions.inScaled = srcOptions.inScaled;
        destOptions.inScreenDensity = srcOptions.inScreenDensity;
        destOptions.inTargetDensity = srcOptions.inTargetDensity;
        destOptions.inTempStorage = srcOptions.inTempStorage;
        if (Build.VERSION.SDK_INT >= 10) copyOptions10(srcOptions, destOptions);
        if (Build.VERSION.SDK_INT >= 11) copyOptions11(srcOptions, destOptions);
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD_MR1)
    private static void copyOptions10(Options srcOptions, Options destOptions) {
        destOptions.inPreferQualityOverSpeed = srcOptions.inPreferQualityOverSpeed;
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    private static void copyOptions11(Options srcOptions, Options destOptions) {
        destOptions.inBitmap = srcOptions.inBitmap;
        destOptions.inMutable = srcOptions.inMutable;
    }

    /**
     * @return Original {@linkplain MemoryCacheUtil#generateKey(String, ImageSize) image key} (used in memory cache).
     */
    public String getImageKey() {
        return this.imageKey;
    }

    /**
     * @return Image URI for decoding (usually image from disc cache)
     */
    public String getImageUri() {
        return this.imageUri;
    }

    /**
     * @return Target size for image. Decoded bitmap should close to this size according to {@linkplain ImageScaleType
     * image scale type} and {@linkplain ViewScaleType view scale type}.
     */
    public ImageSize getTargetSize() {
        return this.targetSize;
    }

    /**
     * @return {@linkplain ImageScaleType Scale type for image sampling and scaling}. This parameter affects result size
     * of decoded bitmap.
     */
    public ImageScaleType getImageScaleType() {
        return this.imageScaleType;
    }

    /**
     * @return {@linkplain ViewScaleType View scale type}. This parameter affects result size of decoded bitmap.
     */
    public ViewScaleType getViewScaleType() {
        return this.viewScaleType;
    }

    /**
     * @return Downloader for image loading
     */
    public ImageDownloader getDownloader() {
        return this.downloader;
    }

    /**
     * @return Auxiliary object for downloader
     */
    public Object getExtraForDownloader() {
        return this.extraForDownloader;
    }

    /**
     * @return Decoding options
     */
    public Options getDecodingOptions() {
        return this.decodingOptions;
    }
}