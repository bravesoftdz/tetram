/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ImageUtils.java
 * Last modified by Tetram, on 2014-07-30T16:31:57CEST
 */

package org.tetram.bdtheque.utils;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.jetbrains.annotations.NonNls;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.EnumSet;

/**
 * Created by Thierry on 16/06/2014.
 */
public class ImageUtils {

    @NonNls
    public static final String JPG_FORMAT = "jpg";

    private static Color changeLight(int value, int fromValue, int toValue, Color fromColor, Color toColor) {
        int rc = fromColor.getRed() + ((toColor.getRed() - fromColor.getRed()) * (value - fromValue) / (toValue - fromValue));
        int gc = fromColor.getGreen() + ((toColor.getGreen() - fromColor.getGreen()) * (value - fromValue) / (toValue - fromValue));
        int bc = fromColor.getBlue() + ((toColor.getBlue() - fromColor.getBlue()) * (value - fromValue) / (toValue - fromValue));

        return new Color(
                Math.max(0, Math.min(255, rc)),
                Math.max(0, Math.min(255, gc)),
                Math.max(0, Math.min(255, bc)),
                100
        );
    }

    public static BufferedImage resizePicture(BufferedImage bufferedImage, Integer height, Integer width, boolean antiAliasing) {
        return resizePicture(bufferedImage, height, width, ScaleOption.ALL, antiAliasing);
    }

    public static BufferedImage resizePicture(BufferedImage bufferedImage, Integer height, Integer width, EnumSet<ScaleOption> scaleOptions, boolean antiAliasing) {
        return resizePicture(bufferedImage, height, width, scaleOptions, antiAliasing, false, 0);
    }

    public static BufferedImage resizePicture(BufferedImage bufferedImage, Integer height, Integer width, EnumSet<ScaleOption> scaleOptions, boolean antiAliasing, boolean cadre, int effet3D) {
        int newHeight, newWidth;
        if (height == null && width == null) {
            newHeight = bufferedImage.getHeight();
            newWidth = bufferedImage.getWidth();
        } else {
            if (height == null) {
                newWidth = width;
                newHeight = newWidth * bufferedImage.getHeight() / bufferedImage.getWidth();
            } else {
                newHeight = height;
                newWidth = newHeight * bufferedImage.getWidth() / bufferedImage.getHeight();
                if (width != null && newWidth > width) {
                    newWidth = width;
                    newHeight = newWidth * bufferedImage.getHeight() / bufferedImage.getWidth();
                }
            }

            if (((height == null ? Integer.MIN_VALUE : height) > bufferedImage.getHeight() || (width == null ? Integer.MIN_VALUE : width) > bufferedImage.getWidth()) && !scaleOptions.contains(ScaleOption.ALLOW_UP)) {
                newHeight = bufferedImage.getHeight();
                newWidth = bufferedImage.getWidth();
            }
            if (((height == null ? Integer.MAX_VALUE : height) < bufferedImage.getHeight() || (width == null ? Integer.MAX_VALUE : width) < bufferedImage.getWidth()) && !scaleOptions.contains(ScaleOption.ALLOW_DOWN)) {
                newHeight = bufferedImage.getHeight();
                newWidth = bufferedImage.getWidth();
            }
        }
        newHeight -= effet3D;
        newWidth -= effet3D;

        Image img = bufferedImage.getScaledInstance(newWidth, newHeight, antiAliasing ? Image.SCALE_SMOOTH : Image.SCALE_FAST);

        BufferedImage newBufferedImage = new BufferedImage(newWidth + effet3D, newHeight + effet3D, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newBufferedImage.createGraphics();
        g.setBackground(Color.WHITE);
        g.fillRect(0, 0, newBufferedImage.getWidth(), newBufferedImage.getHeight());
        g.drawImage(img, 0, 0, null);
        if (cadre) {
            g.setColor(Color.BLACK);
            g.drawRect(0, 0, newWidth, newHeight);
        }
        if (effet3D > 0) {
            for (int i = 1; i <= effet3D; i++) {
                g.setColor(Color.GRAY);
                g.drawLine(i, newHeight + i, newWidth + i, newHeight + i);
                g.drawLine(newWidth + i, newHeight + i, newWidth + i, i);
            }
        }

        g.dispose();

        return newBufferedImage;
    }

    public static byte[] getJPEGStream(File file) {
        return getJPEGStream(file, null, null, false);
    }

    public static byte[] getJPEGStream(File file, Integer height, Integer width, boolean antiAliasing) {
        return getJPEGStream(file, height, width, ScaleOption.ALL, antiAliasing);
    }

    public static byte[] getJPEGStream(File file, Integer height, Integer width, EnumSet<ScaleOption> scaleOptions, boolean antiAliasing) {
        return getJPEGStream(file, height, width, scaleOptions, antiAliasing, false, 0);
    }

    public static byte[] getJPEGStream(File file, Integer height, Integer width, EnumSet<ScaleOption> scaleOptions, boolean antiAliasing, boolean cadre, int effet3D) {
        try {
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            // write to jpeg file
            ImageIO.write(resizePicture(ImageIO.read(file), height, width, scaleOptions, antiAliasing, cadre, effet3D), JPG_FORMAT, output);

            return output.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public enum ScaleOption {
        ALLOW_UP, ALLOW_DOWN;
        public static final EnumSet<ScaleOption> ALL = EnumSet.allOf(ScaleOption.class);
    }
}
