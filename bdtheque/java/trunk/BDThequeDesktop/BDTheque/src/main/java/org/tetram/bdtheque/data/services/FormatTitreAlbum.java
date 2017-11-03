/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FormatTitreAlbum.java
 * Last modified by Tetram, on 2014-08-26T12:05:12CEST
 */
package org.tetram.bdtheque.data.services;

import org.tetram.bdtheque.utils.I18nSupport;

import java.text.MessageFormat;

/**
 * Created by Thierry on 25/06/2014.
 */
public enum FormatTitreAlbum {

    ALBUM_SERIE_TOME("{0} ({1} - {2})"), TOME_ALBUM_SERIE("{2} - {0} ({1})");

    private final String labelFormat;

    FormatTitreAlbum(String labelFormat) {
        this.labelFormat = labelFormat;
    }

    public String getLabel() {
        return MessageFormat.format(labelFormat, I18nSupport.message("Album/one"), I18nSupport.message("Série/one"), I18nSupport.message("Tome"));
    }

}
