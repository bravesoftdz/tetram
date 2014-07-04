package org.tetram.bdtheque.data.services;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;

import java.io.File;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface UserPreferences {
    void save();

    ObjectProperty<Locale> localeProperty();

    Locale getLocale();

    void setLocale(Locale locale);

    ObjectProperty<File> repImagesProperty();

    File getRepImages();

    void setRepImages(File value);

    ObjectProperty<FormatTitreAlbum> formatTitreAlbumProperty();

    FormatTitreAlbum getFormatTitreAlbum();

    void setFormatTitreAlbum(FormatTitreAlbum value);

    BooleanProperty serieObligatoireAlbumsProperty();

    boolean isSerieObligatoireAlbums();

    void setSerieObligatoireAlbums(boolean value);

    BooleanProperty serieObligatoireParaBDProperty();

    boolean isSerieObligatoireParaBD();

    void setSerieObligatoireParaBD(boolean value);

    BooleanProperty antiAliasingProperty();

    boolean isAntiAliasing();

    void setAntiAliasing(boolean value);

    BooleanProperty afficheNoteListesProperty();

    boolean isAfficheNoteListes();

    void setAfficheNoteListes(boolean value);

    BooleanProperty imagesStockeesProperty();

    boolean isImagesStockees();

    void setImagesStockees(boolean value);

    ObjectProperty<File> databaseProperty();

    File getDatabase();

    void setDatabase(File value);

    NumberFormat getCurrencyFormatter();
}
