/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UserPreferencesImpl.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */
package org.tetram.bdtheque.data.services;

import javafx.beans.property.*;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.tetram.bdtheque.gui.controllers.ApplicationMode;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Locale;
import java.util.Properties;

/**
 * Created by Thierry on 15/06/2014.
 */
@Service
@Lazy
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)

public class UserPreferencesImpl implements UserPreferences {

    @NonNls
    public static final String PREF_DATABASE = "database";
    @NonNls
    public static final String PREF_DATABASE_DEFAULT = null;
    @NonNls
    public static final String PREF_DATABASE_SERVER = "databaseServer";
    @NonNls
    public static final String PREF_DATABASE_SERVER_DEFAULT = null;
    @NonNls
    public static final String PREF_REP_IMAGES = "RepImages";
    @NonNls
    public static final String PREF_REP_IMAGES_DEFAULT = "RepImages";

    @NonNls
    private static final String PREF_FORMAT_TITRE_ALBUM = "FormatTitreAlbum";
    private static final FormatTitreAlbum PREF_FORMAT_TITRE_ALBUM_DEFAULT = FormatTitreAlbum.ALBUM_SERIE_TOME;
    @NonNls
    private static final String PREF_SERIE_OBLIGATOIRE_ALBUMS = "SerieObligatoireAlbums";
    private static final boolean PREF_SERIE_OBLIGATOIRE_ALBUMS_DEFAULT = false;
    @NonNls
    private static final String PREF_SERIE_OBLIGATOIRE_PARABD = "SerieObligatoireParaBD";
    private static final boolean PREF_SERIE_OBLIGATOIRE_PARABD_DEFAULT = false;
    @NonNls
    private static final String PREF_ANTI_ALIASING = "AntiAliasing";
    private static final boolean PREF_ANTI_ALIASING_DEFAULT = true;
    @NonNls
    private static final String PREF_IMAGES_STOCKEES = "ImagesStockees";
    private static final boolean PREF_IMAGES_STOCKEES_DEFAULT = false;
    @NonNls
    private static final String PREF_LOCALE = "Locale";
    private static final Locale PREF_LOCALE_DEFAULT = Locale.getDefault();
    @NonNls
    private static final String PREF_AFFICHE_NOTE_LISTES = "AfficheNotesListes";
    private static final boolean PREF_AFFICHE_NOTE_LISTES_DEFAULT = true;
    @NonNls
    private static final String PREF_MODE_OUVERTURE = "ModeOuverture";
    private static final ApplicationMode PREF_MODE_OUVERTURE_DEFAULT = ApplicationMode.CONSULTATION;

    @Autowired
    private ApplicationContext applicationContext;
    private Properties defaultPrefs = null;
    private Properties prefs = null;

    private BooleanProperty afficheNoteListes = null;
    private ObjectProperty<Locale> locale = null;
    private ObjectProperty<File> repImages = null;
    private ObjectProperty<FormatTitreAlbum> formatTitreAlbum = null;
    private BooleanProperty serieObligatoireAlbums = null;
    private BooleanProperty serieObligatoireParaBD = null;
    private BooleanProperty antiAliasing = null;
    private BooleanProperty imagesStockees = null;
    private ObjectProperty<File> database = null;
    private ObjectProperty<ApplicationMode> modeOuverture = null;
    private StringProperty databaseServer = null;

    public UserPreferencesImpl() {
    }

    // pour rester cohérent avec le reste, ce constructeur ne sert que lorsqu'on a besoin de l'instance en dehors de Spring
    // @Autowired
    public UserPreferencesImpl(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    private Properties getDefaultPrefs() {
        if (defaultPrefs != null) return defaultPrefs;

        defaultPrefs = new Properties();

        Path configPath = applicationContext.getUserConfigFile().getParentFile().toPath();
        Path userDataPath = new File(applicationContext.getUserDataDirectory()).toPath();
        boolean userConfig = false;
        try {
            userConfig = Files.isSameFile(configPath, userDataPath);
        } catch (IOException e) {
            e.printStackTrace();
        }
        if (userConfig) {
            // DatabasePath := TPath.Combine(AppData, DatabasePath);
            defaultPrefs.put(PREF_REP_IMAGES, new File(applicationContext.getUserDataDirectory(), PREF_REP_IMAGES_DEFAULT));
            // RepScripts := TPath.Combine(CommonAppData, RepScripts);
            // RepWebServer := TPath.Combine(CommonAppData, RepWebServer);
        } else {
            // DatabasePath := TPath.Combine(parentPath, DatabasePath);
            defaultPrefs.put(PREF_REP_IMAGES, new File(System.getProperty("user.dir"), PREF_REP_IMAGES_DEFAULT));
            // RepScripts := TPath.Combine(parentPath, RepScripts);
            // RepWebServer := TPath.Combine(parentPath, RepWebServer);
        }

        defaultPrefs.setProperty(PREF_FORMAT_TITRE_ALBUM, String.valueOf(PREF_FORMAT_TITRE_ALBUM_DEFAULT.getValue()));
        defaultPrefs.setProperty(PREF_SERIE_OBLIGATOIRE_ALBUMS, String.valueOf(PREF_SERIE_OBLIGATOIRE_ALBUMS_DEFAULT));
        defaultPrefs.setProperty(PREF_SERIE_OBLIGATOIRE_PARABD, String.valueOf(PREF_SERIE_OBLIGATOIRE_PARABD_DEFAULT));
        defaultPrefs.setProperty(PREF_ANTI_ALIASING, String.valueOf(PREF_ANTI_ALIASING_DEFAULT));
        defaultPrefs.setProperty(PREF_AFFICHE_NOTE_LISTES, String.valueOf(PREF_AFFICHE_NOTE_LISTES_DEFAULT));
        defaultPrefs.setProperty(PREF_IMAGES_STOCKEES, String.valueOf(PREF_IMAGES_STOCKEES_DEFAULT));
        defaultPrefs.setProperty(PREF_LOCALE, PREF_LOCALE_DEFAULT.toLanguageTag());
        defaultPrefs.setProperty(PREF_MODE_OUVERTURE, String.valueOf(PREF_MODE_OUVERTURE_DEFAULT));

        return defaultPrefs;
    }

    private Properties getPrefs() {
        if (prefs == null) {
            InputStream input = null;
            try {
                prefs = new Properties(getDefaultPrefs());
                if (applicationContext.getUserConfigFile().exists()) {
                    input = new FileInputStream(applicationContext.getUserConfigFile());
                    prefs.load(input);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (input != null) {
                    try {
                        input.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        return prefs;
    }

    @Override
    public void save() {
        if (prefs == null) return;

        OutputStream output = null;
        try {
            output = new FileOutputStream(applicationContext.getUserConfigFile(), false);
            prefs.store(output, null);
        } catch (IOException io) {
            io.printStackTrace();
        } finally {
            if (output != null) {
                try {
                    output.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private String getStringPref(String key) {
        return getPrefs().getProperty(key);
    }

    private int getIntPref(String key) {
        return Integer.valueOf(getPrefs().getProperty(key));
    }

    private boolean getBooleanPref(String key) {
        return Boolean.valueOf(getPrefs().getProperty(key));
    }

    private File getFilePref(String key) {
        String stringPref = getStringPref(key);
        return StringUtils.isNullOrEmpty(stringPref) ? null : new File(stringPref);
    }

    private Object setPref(String key, String value) {
        if (StringUtils.isNullOrEmpty(value))
            return getPrefs().remove(key);
        return getPrefs().setProperty(key, value);
    }

    private Object setPref(String key, int value) {
        return getPrefs().setProperty(key, String.valueOf(value));
    }

    private Object setPref(String key, boolean value) {
        return getPrefs().setProperty(key, String.valueOf(value));
    }

    private Object setPref(String key, File value) {
        return setPref(key, value == null ? null : value.getAbsolutePath());
    }

    @Override
    public ObjectProperty<File> repImagesProperty() {
        if (repImages == null)
            repImages = new SimpleObjectProperty<File>(this, "repImages", getFilePref(PREF_REP_IMAGES)) {
                @Override
                public void set(File newValue) {
                    setPref(PREF_REP_IMAGES, newValue);
                    super.set(newValue);
                }
            };
        return repImages;
    }

    @Override
    public ObjectProperty<FormatTitreAlbum> formatTitreAlbumProperty() {
        if (formatTitreAlbum == null)
            formatTitreAlbum = new SimpleObjectProperty<FormatTitreAlbum>(this, "formatTitreAlbum", FormatTitreAlbum.fromValue(getIntPref(PREF_FORMAT_TITRE_ALBUM))) {
                @Override
                public void set(FormatTitreAlbum newValue) {
                    setPref(PREF_FORMAT_TITRE_ALBUM, String.valueOf(newValue.getValue()));
                    super.set(newValue);
                }
            };
        return formatTitreAlbum;
    }

    @Override
    public BooleanProperty serieObligatoireAlbumsProperty() {
        if (serieObligatoireAlbums == null)
            serieObligatoireAlbums = new SimpleBooleanProperty(this, "serieObligatoireAlbums", getBooleanPref(PREF_SERIE_OBLIGATOIRE_ALBUMS)) {
                @Override
                public void set(boolean newValue) {
                    setPref(PREF_SERIE_OBLIGATOIRE_ALBUMS, newValue);
                    super.set(newValue);
                }
            };
        return serieObligatoireAlbums;
    }

    @Override
    public BooleanProperty serieObligatoireParaBDProperty() {
        if (serieObligatoireParaBD == null)
            serieObligatoireParaBD = new SimpleBooleanProperty(this, "serieObligatoireParaBD", getBooleanPref(PREF_SERIE_OBLIGATOIRE_PARABD)) {
                @Override
                public void set(boolean newValue) {
                    setPref(PREF_SERIE_OBLIGATOIRE_PARABD, newValue);
                    super.set(newValue);
                }
            };
        return serieObligatoireParaBD;
    }

    @Override
    public BooleanProperty antiAliasingProperty() {
        if (antiAliasing == null)
            antiAliasing = new SimpleBooleanProperty(this, "antiAliasing", getBooleanPref(PREF_ANTI_ALIASING)) {
                @Override
                public void set(boolean newValue) {
                    setPref(PREF_ANTI_ALIASING, newValue);
                    super.set(newValue);
                }
            };
        return antiAliasing;
    }

    @Override
    public BooleanProperty afficheNoteListesProperty() {
        if (afficheNoteListes == null)
            afficheNoteListes = new SimpleBooleanProperty(this, "afficheNoteListes", getBooleanPref(PREF_AFFICHE_NOTE_LISTES)) {
                @Override
                public void set(boolean newValue) {
                    setPref(PREF_AFFICHE_NOTE_LISTES, newValue);
                    super.set(newValue);
                }
            };
        return afficheNoteListes;
    }

    @Override
    public BooleanProperty imagesStockeesProperty() {
        if (imagesStockees == null)
            imagesStockees = new SimpleBooleanProperty(this, "imagesStockees", getBooleanPref(PREF_IMAGES_STOCKEES)) {
                @Override
                public void set(boolean newValue) {
                    setPref(PREF_IMAGES_STOCKEES, newValue);
                    super.set(newValue);
                }
            };
        return imagesStockees;
    }

    @Override
    public ObjectProperty<ApplicationMode> modeOuvertureProperty() {
        if (modeOuverture == null) {
            modeOuverture = new SimpleObjectProperty<ApplicationMode>(this, "modeOuverture", ApplicationMode.valueOf(getStringPref(PREF_MODE_OUVERTURE))) {
                @Override
                public void set(ApplicationMode newValue) {
                    setPref(PREF_MODE_OUVERTURE, String.valueOf(newValue));
                    super.set(newValue);
                }
            };
        }
        return modeOuverture;
    }

    @Override
    public ObjectProperty<File> databaseProperty() {
        if (database == null)
            database = new SimpleObjectProperty<File>(this, "database", getFilePref(PREF_DATABASE)) {
                @Override
                public void set(File newValue) {
                    setPref(PREF_DATABASE, newValue);
                    super.set(newValue);
                }
            };
        return database;
    }

    @Override
    public StringProperty databaseServerProperty() {
        if (databaseServer == null)
            databaseServer = new SimpleStringProperty(this, "databaseServer", getStringPref(PREF_DATABASE_SERVER)) {
                @Override
                public void set(String newValue) {
                    setPref(PREF_DATABASE_SERVER, newValue);
                    super.set(newValue);
                }
            };
        return databaseServer;
    }

    @Override
    public ObjectProperty<Locale> localeProperty() {
        if (locale == null)
            locale = new SimpleObjectProperty<Locale>(this, "locale", Locale.forLanguageTag(getStringPref(PREF_LOCALE))) {
                @Override
                public void set(Locale newValue) {
                    setPref(PREF_LOCALE, newValue.toLanguageTag());
                    super.set(newValue);
                }
            };
        return locale;
    }
}
