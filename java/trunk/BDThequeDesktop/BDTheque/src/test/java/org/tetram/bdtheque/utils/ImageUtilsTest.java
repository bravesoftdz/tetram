/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ImageUtilsTest.java
 * Last modified by Tetram, on 2014-07-30T16:04:49CEST
 */

package org.tetram.bdtheque.utils;

import org.apache.commons.io.IOUtils;
import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class ImageUtilsTest {

    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_SOURCE_JPG = "/org/tetram/bdtheque/utils/planche-getjpegstream-source.jpg";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_NORESIZE_JPG = "/org/tetram/bdtheque/utils/planche-getjpegstream-noresize.jpg";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_JPG = "/org/tetram/bdtheque/utils/planche-getjpegstream-resizeh500.jpg";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_ANTIALIASING_JPG = "/org/tetram/bdtheque/utils/planche-getjpegstream-resizeh500-antialiasing.jpg";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_CADRE_JPG = "/org/tetram/bdtheque/utils/planche-getjpegstream-resizeh500-cadre.jpg";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_UTILS_MIRE = "/org/tetram/bdtheque/utils/mire";
    @NonNls
    private static final String PNG = ".png";
    @NonNls
    private static final String GIF = ".gif";
    @NonNls
    private static final String JPG = ".jpg";

    @Test
    public void testGetJPEGStreamNoResize() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_SOURCE_JPG).toURI())
        );
        Assert.assertNotNull(result);

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_NORESIZE_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

    @Test
    public void testGetJPEGStreamResizeH500() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_SOURCE_JPG).toURI()),
                500,
                null,
                false
        );
        Assert.assertNotNull(result);

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

    @Test
    public void testGetJPEGStreamResizeH500Antialiasing() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_SOURCE_JPG).toURI()),
                500,
                null,
                true
        );
        Assert.assertNotNull(result);

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_ANTIALIASING_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

    @Test
    public void testGetJPEGStreamResizeH500Cadre() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_SOURCE_JPG).toURI()),
                500,
                null,
                ImageUtils.ScaleOption.ALL,
                true,
                true,
                3
        );
        Assert.assertNotNull(result);

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_PLANCHE_RESIZEH500_CADRE_JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

    @Test
    public void testGetJPEGStreamPNG() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_MIRE + PNG).toURI())
        );
        Assert.assertNotNull(result);

/*
        try (FileOutputStream f = new FileOutputStream("d:\\mire.png.jpg")){
            f.write(result);
        }
*/

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_MIRE + PNG + JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

    @Test
    public void testGetJPEGStreamGIF() throws Exception {
        byte[] result = ImageUtils.getJPEGStream(
                new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_MIRE + GIF).toURI())
        );
        Assert.assertNotNull(result);

/*
        try (FileOutputStream f = new FileOutputStream("d:\\mire.gif.jpg")){
            f.write(result);
        }
*/

        File f = new File(this.getClass().getResource(ORG_TETRAM_BDTHEQUE_UTILS_MIRE + GIF + JPG).toURI());
        ByteArrayInputStream resultStream = new ByteArrayInputStream(result);
        try (InputStream stream = new FileInputStream(f)) {
            Assert.assertTrue(IOUtils.contentEquals(resultStream, stream));
        }
    }

}