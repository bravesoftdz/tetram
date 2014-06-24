package org.tetram.bdtheque.data.services;

import java.util.Locale;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface UserPreferences {
    void reload();

    void save();

    Locale getLocale();

    void setLocale(Locale locale);

    String getRepImages();

    void setRepImages(String value);

    int getFormatTitreAlbum();

    void setFormatTitreAlbum(int value);

    boolean isSerieObligatoireAlbums();

    void setSerieObligatoireAlbums(boolean value);

    boolean isSerieObligatoireParaBD();

    void setSerieObligatoireParaBD(boolean value);

    boolean isAntiAliasing();

    void setAntiAliasing(boolean value);

    boolean isImagesStockees();

    void setImagesStockees(boolean value);
}
