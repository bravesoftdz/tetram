package org.tetram.bdtheque.utils;

import org.apache.commons.io.output.ByteArrayOutputStream;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * Created by Thierry on 14/06/2014.
 */
public class FileUtils extends org.apache.commons.io.FileUtils {


    public static BufferedImage resizePicture(BufferedImage bufferedImage, Integer height, Integer width, boolean antiAliasing) {
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
        }
        // create a blank, RGB with a white background
        BufferedImage newBufferedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = newBufferedImage.createGraphics();
        if (antiAliasing) {
            g.setComposite(AlphaComposite.Src);
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        }
        g.drawImage(bufferedImage, 0, 0, Color.WHITE, null);
        g.dispose();

        return newBufferedImage;
    }

    public static byte[] getJPEGStream(File file) {
        return getJPEGStream(file, null, null, false);
    }

    @SuppressWarnings("HardCodedStringLiteral")
    public static byte[] getJPEGStream(File file, Integer height, Integer width, boolean antiAliasing) {
        BufferedImage bufferedImage;
        try {
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            // write to jpeg file
            ImageIO.write(resizePicture(ImageIO.read(file), height, width, antiAliasing), "jpg", output);

            return output.toByteArray();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
