package org.tetram.bdtheque.database;

@SuppressWarnings("UnusedDeclaration")
public class DDLConstants {

    public static final String SERIES_TABLENAME = "SERIES";
    public static final String SERIES_ID = "ID_SERIE";
    public static final String SERIES_TITRE = "TITRESERIE";
    public static final String SERIES_INITIALE = "INITIALETITRESERIE";
    public static final String SERIES_SITEWEB = "SITEWEB";
    public static final String SERIES_SUJET = "SUJETSERIE";
    public static final String SERIES_NOTES = "REMARQUESSERIE";

    public static final String ALBUMS_TABLENAME = "ALBUMS";
    public static final String ALBUMS_ID = "ID_ALBUM";
    public static final String ALBUMS_TITRE = "TITREALBUM";
    public static final String ALBUMS_INITIALE = "INITIALETITREALBUM";
    public static final String ALBUMS_TOME = "TOME";
    public static final String ALBUMS_TOMEDEBUT = "TOMEDEBUT";
    public static final String ALBUMS_TOMEFIN = "TOMEFIN";
    public static final String ALBUMS_HORSSERIE = "HORSSERIE";
    public static final String ALBUMS_INTEGRALE = "INTEGRALE";
    public static final String ALBUMS_MOISPARUTION = "MOISPARUTION";
    public static final String ALBUMS_ANNEEPARUTION = "ANNEEPARUTION";
    public static final String ALBUMS_NOTATION = "NOTATION";
    public static final String ALBUMS_ACHAT = "ACHAT";
    public static final String ALBUMS_COMPLET = "COMPLET";
    public static final String ALBUMS_SUJET = "SUJETALBUM";
    public static final String ALBUMS_NOTES = "REMARQUESALBUM";

    public static final String EDITEURS_TABLENAME = "EDITEURS";
    public static final String EDITEURS_ID = "ID_EDITEUR";
    public static final String EDITEURS_NOM = "NOMEDITEUR";
    public static final String EDITEURS_INITIALE = "INITIALENOMEDITEUR";
    public static final String EDITEURS_SITEWEB = "SITEWEB";

    public static final String COLLECTIONS_TABLENAME = "COLLECTIONS";
    public static final String COLLECTIONS_ID = "ID_COLLECTION";
    public static final String COLLECTIONS_NOM = "NOMCOLLECTION";

    public static final String PERSONNES_TABLENAME = "PERSONNES";
    public static final String PERSONNES_ID = "ID_PERSONNE";
    public static final String PERSONNES_NOM = "NOMPERSONNE";
    public static final String PERSONNES_INITIALE = "INITIALENOMPERSONNE";
    public static final String PERSONNES_SITEWEB = "SITEWEB";
    public static final String PERSONNES_BIOGRAPHIE = "BIOGRAPHIE";

    public static final String AUTEURS_TABLENAME = "AUTEURS";
    public static final String AUTEURS_ID = "ID_AUTEUR";
    public static final String AUTEURS_METIER = "METIER";

    public static final String AUTEURS_SERIES_TABLENAME = "AUTEURS_SERIES";
    public static final String AUTEURS_SERIES_ID = "ID_AUTEUR_SERIES";
    public static final String AUTEURS_SERIES_METIER = "METIER";

    public static final String GENRES_TABLENAME = "GENRES";
    public static final String GENRES_ID = "ID_GENRE";
    public static final String GENRES_NOM = "GENRE";

    public static final String GENRESERIES_TABLENAME = "GENRESERIES";

    public static final String EDITIONS_TABLENAME = "EDITIONS";
    public static final String EDITIONS_ID = "ID_EDITION";
    public static final String EDITIONS_ISBN = "ISBN";
}
