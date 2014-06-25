package org.tetram.bdtheque.data.services;

import org.tetram.bdtheque.utils.I18nSupport;

import java.text.MessageFormat;

/**
 * Created by Thierry on 25/06/2014.
 */
public enum FormatTitreAlbum {

    ALBUM_SERIE_TOME(0, "{0} ({1} - {2})"), TOME_ALBUM_SERIE(1, "{2} - {0} ({1})");

    private final int value;
    private final String format;

    FormatTitreAlbum(int value, String format) {
        this.value = value;
        this.format = format;
    }

    public String getLabel() {
        return MessageFormat.format(format, I18nSupport.message("Album"), I18nSupport.message("Série"), I18nSupport.message("Tome"));
    }

    public int getValue() {
        return value;
    }

    @Override
    public String toString() {
        return getLabel();
    }

    public static FormatTitreAlbum fromValue(int value) {
        for (FormatTitreAlbum formatTitreAlbum : values()) if (formatTitreAlbum.value == value) return formatTitreAlbum;
        return null;
    }
}
