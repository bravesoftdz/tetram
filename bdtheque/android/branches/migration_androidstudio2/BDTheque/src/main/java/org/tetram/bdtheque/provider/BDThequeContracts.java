package org.tetram.bdtheque.provider;

import android.provider.BaseColumns;

public interface BDThequeContracts extends BaseColumns {
    public static final String SCHEME = "content://";
    public static final String AUTORITHY = "org.tetram.bdtheque.provider";

    public static final String MIME_TYPE_ROW = "vnd.android.cursor.item";
    public static final String MIME_TYPE_ROWS = "vnd.android.cursor.dir";
    public static final String MIME_SUBTYPE_PREFIX = "vnd." + AUTORITHY;
    public static final String MIME_TYPE_FORMAT = "%.1s/" + MIME_SUBTYPE_PREFIX + ".%.2s";

    public static final String TABLE_ALBUM = "album";
    public static final String TABLE_SERIE = "serie";

    public static final String FIELD_ALBUM_TITRE = "titrealbum";
    public static final String FIELD_ALBUM_INITIALE = "initialetitrealbum";
    public static final String FIELD_ALBUM_TOME = "tome";
    public static final String FIELD_ALBUM_TOMEDEBUT = "tomedebut";
    public static final String FIELD_ALBUM_TOMEFIN = "tomefin";
    public static final String FIELD_ALBUM_HORSSERIE = "horsserie";
    public static final String FIELD_ALBUM_INTEGRALE = "integrale";
    public static final String FIELD_ALBUM_MOISPARUTION = "moisparution";
    public static final String FIELD_ALBUM_ANNEEPARUTION = "anneeparution";
    public static final String FIELD_ALBUM_NOTATION = "notation";
    public static final String FIELD_ALBUM_ACHAT = "achat";
    public static final String FIELD_ALBUM_COMPLET = "complet";
    public static final String FIELD_ALBUM_SUJET = "sujetalbum";
    public static final String FIELD_ALBUM_NOTES = "remarquesalbum";
}
