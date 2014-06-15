package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 15/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
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
