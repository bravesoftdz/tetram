package org.tetram.bdtheque.data.services;

import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
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
@Scope
@SuppressWarnings("UnusedDeclaration")
public class UserPreferencesImpl implements UserPreferences {

    @NonNls
    public static final String PREF_DATABASE = "database";
    @NonNls
    public static final String PREF_DATABASE_DEFAULT = null;
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

    @Autowired
    private ApplicationContext applicationContext;
    private Properties defaultPrefs = null;
    private Properties prefs = null;

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

    public void reload() {
        prefs = null;
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
    public File getRepImages() {
        return getFilePref(PREF_REP_IMAGES);
    }

    @Override
    public void setRepImages(File value) {
        setPref(PREF_REP_IMAGES, value);
    }

    @Override
    public FormatTitreAlbum getFormatTitreAlbum() {
        return FormatTitreAlbum.fromValue(getIntPref(PREF_FORMAT_TITRE_ALBUM));
    }

    @Override
    public void setFormatTitreAlbum(FormatTitreAlbum value) {
        setPref(PREF_FORMAT_TITRE_ALBUM, String.valueOf(value.getValue()));
    }

    @Override
    public boolean isSerieObligatoireAlbums() {
        return getBooleanPref(PREF_SERIE_OBLIGATOIRE_ALBUMS);
    }

    @Override
    public void setSerieObligatoireAlbums(boolean value) {
        setPref(PREF_SERIE_OBLIGATOIRE_ALBUMS, value);
    }

    @Override
    public boolean isSerieObligatoireParaBD() {
        return getBooleanPref(PREF_SERIE_OBLIGATOIRE_PARABD);
    }

    @Override
    public void setSerieObligatoireParaBD(boolean value) {
        setPref(PREF_SERIE_OBLIGATOIRE_PARABD, value);
    }

    @Override
    public boolean isAntiAliasing() {
        return getBooleanPref(PREF_ANTI_ALIASING);
    }

    @Override
    public void setAntiAliasing(boolean value) {
        setPref(PREF_ANTI_ALIASING, value);
    }

    @Override
    public boolean isAfficheNoteListes() {
        return getBooleanPref(PREF_AFFICHE_NOTE_LISTES);
    }

    @Override
    public void setAfficheNoteListes(boolean value) {
        setPref(PREF_AFFICHE_NOTE_LISTES, value);
    }

    @Override
    public boolean isImagesStockees() {
        return getBooleanPref(PREF_IMAGES_STOCKEES);
    }

    @Override
    public void setImagesStockees(boolean value) {
        setPref(PREF_IMAGES_STOCKEES, value);
    }

    @Override
    public File getDatabase() {
        return getFilePref(PREF_DATABASE);
    }

    @Override
    public void setDatabaseUrl(File value) {
        setPref(PREF_DATABASE, value);
    }

    @Override
    public Locale getLocale() {
        return Locale.forLanguageTag(getStringPref(PREF_LOCALE));
    }

    @Override
    public void setLocale(Locale locale) {
        setPref(PREF_LOCALE, locale.toLanguageTag());
    }

}
