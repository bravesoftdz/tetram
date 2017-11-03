/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ImageStream.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 15/06/2014.
 */

public class ImageStream {

    byte[] data;
    String fileName;
    boolean stockee;

    public byte[] getData() {
        return data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public boolean isStockee() {
        return stockee;
    }

    public void setStockee(boolean stockee) {
        this.stockee = stockee;
    }

}
