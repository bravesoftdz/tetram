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
    public static final String SERIES_NOTATION = "NOTATION";

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
    public static final String EDITIONS_STOCK = "STOCK";
    public static final String EDITIONS_COULEUR = "COULEUR";
    public static final String EDITIONS_DEDICACE = "DEDICACE";
    public static final String EDITIONS_OFFERT = "OFFERT";
    public static final String EDITIONS_ANNEEEDITION = "ANNEEEDITION";
    public static final String EDITIONS_DATEACHAT = "DATEACHAT";
    public static final String EDITIONS_NOTES = "NOTES";
    public static final String EDITIONS_NOMBREDEPAGES = "NOMBREDEPAGES";
    public static final String EDITIONS_NUMEROPERSO = "NUMEROPERSO";
    public static final String EDITIONS_GRATUIT = "GRATUIT";
    public static final String EDITIONS_ANNEECOTE = "ANNEECOTE";
    public static final String EDITIONS_PRIX = "PRIX";
    public static final String EDITIONS_PRIXCOTE = "PRIXCOTE";
    public static final String EDITIONS_ETAT = "ETAT";
    public static final String EDITIONS_RELIURE = "RELIURE";
    public static final String EDITIONS_TYPEEDITION = "TYPEEDITION";
    public static final String EDITIONS_ORIENTATION = "ORIENTATION";
    public static final String EDITIONS_FORMATEDITION = "FORMATEDITION";
    public static final String EDITIONS_SENSLECTURE = "SENSLECTURE";

    public static final String LISTES_TABLENAME = "LISTES";
    public static final String LISTES_ID = "ID_LISTE";
    public static final String LISTES_CATEGORIE = "CATEGORIE";
    public static final String LISTES_REF = "REF";
    public static final String LISTES_ORDRE = "ORDRE";
    public static final String LISTES_DEFAUT = "DEFAUT";
    public static final String LISTES_LIBELLE = "LIBELLE";
}
