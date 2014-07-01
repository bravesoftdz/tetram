package org.tetram.bdtheque.data.services;

import javafx.beans.property.BooleanProperty;

import java.io.File;
import java.util.Locale;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface UserPreferences {
    void reload();

    void save();

    Locale getLocale();

    void setLocale(Locale locale);

    File getRepImages();

    void setRepImages(File value);

    FormatTitreAlbum getFormatTitreAlbum();

    void setFormatTitreAlbum(FormatTitreAlbum value);

    boolean isSerieObligatoireAlbums();

    void setSerieObligatoireAlbums(boolean value);

    boolean isSerieObligatoireParaBD();

    void setSerieObligatoireParaBD(boolean value);

    boolean isAntiAliasing();

    void setAntiAliasing(boolean value);

    boolean isAfficheNoteListes();

    BooleanProperty afficheNoteListesProperty();

    void setAfficheNoteListes(boolean value);

    boolean isImagesStockees();

    void setImagesStockees(boolean value);

    File getDatabase();

    void setDatabaseUrl(File value);

}
