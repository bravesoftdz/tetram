/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UserPreferences.java
 * Last modified by Tetram, on 2014-08-26T09:54:40CEST
 */

package org.tetram.bdtheque.data.services;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.gui.controllers.ApplicationMode;

import java.io.File;
import java.util.Locale;

/**
 * Created by Thierry on 15/06/2014.
 */

public interface UserPreferences {
    void save();

    ObjectProperty<Locale> localeProperty();

    default Locale getLocale() {
        return localeProperty().get();
    }

    default void setLocale(Locale locale) {
        localeProperty().set(locale);
    }

    StringProperty currencySymbolProperty();

    default String getCurrencySymbol() {
        return currencySymbolProperty().get();
    }

    default void setCurrencySymbol(String currencySymbol) {
        currencySymbolProperty().set(currencySymbol);
    }

    ObjectProperty<File> repImagesProperty();

    default File getRepImages() {
        return repImagesProperty().get();
    }

    default void setRepImages(File value) {
        repImagesProperty().set(value);
    }

    ObjectProperty<FormatTitreAlbum> formatTitreAlbumProperty();

    default FormatTitreAlbum getFormatTitreAlbum() {
        return formatTitreAlbumProperty().get();
    }

    default void setFormatTitreAlbum(FormatTitreAlbum value) {
        formatTitreAlbumProperty().set(value);
    }

    BooleanProperty serieObligatoireAlbumsProperty();

    default boolean isSerieObligatoireAlbums() {
        return serieObligatoireAlbumsProperty().get();
    }

    default void setSerieObligatoireAlbums(boolean value) {
        serieObligatoireAlbumsProperty().set(value);
    }

    BooleanProperty serieObligatoireParaBDProperty();

    default boolean isSerieObligatoireParaBD() {
        return serieObligatoireParaBDProperty().get();
    }

    default void setSerieObligatoireParaBD(boolean value) {
        serieObligatoireParaBDProperty().set(value);
    }

    BooleanProperty antiAliasingProperty();

    default boolean isAntiAliasing() {
        return antiAliasingProperty().get();
    }

    default void setAntiAliasing(boolean value) {
        antiAliasingProperty().set(value);
    }

    BooleanProperty afficheNoteListesProperty();

    default boolean isAfficheNoteListes() {
        return afficheNoteListesProperty().get();
    }

    default void setAfficheNoteListes(boolean value) {
        afficheNoteListesProperty().set(value);
    }

    BooleanProperty imagesStockeesProperty();

    default boolean isImagesStockees() {
        return imagesStockeesProperty().get();
    }

    default void setImagesStockees(boolean value) {
        imagesStockeesProperty().set(value);
    }

    ObjectProperty<File> databaseProperty();

    default File getDatabase() {
        return databaseProperty().get();
    }

    default void setDatabase(File value) {
        databaseProperty().set(value);
    }

    StringProperty databaseServerProperty();

    default String getDatabaseServer() {
        return databaseServerProperty().get();
    }

    default void setDatabaseServer(String value) {
        databaseServerProperty().set(value);
    }

    ObjectProperty<ApplicationMode> modeOuvertureProperty();

    default ApplicationMode getModeOuverture() {
        return modeOuvertureProperty().get();
    }

    default void setModeOuverture(ApplicationMode value) {
        modeOuvertureProperty().set(value);
    }
}
