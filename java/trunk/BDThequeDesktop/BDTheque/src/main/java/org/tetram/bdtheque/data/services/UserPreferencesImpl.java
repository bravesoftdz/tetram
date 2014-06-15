package org.tetram.bdtheque.data.services;

import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

/**
 * Created by Thierry on 15/06/2014.
 */
@Service
@Lazy
@Scope
@SuppressWarnings("UnusedDeclaration")
public class UserPreferencesImpl implements UserPreferences {

    @Autowired
    private ApplicationContext applicationContext;

    @NonNls
    public static final String PREF_REP_IMAGES = "RepImages";

    private Properties defaultPrefs = null;
    private Properties prefs = null;

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
        if (userConfig){
            // DatabasePath := TPath.Combine(AppData, DatabasePath);
            defaultPrefs.put(PREF_REP_IMAGES, new File(applicationContext.getUserDataDirectory(), PREF_REP_IMAGES));
            // RepScripts := TPath.Combine(CommonAppData, RepScripts);
            // RepWebServer := TPath.Combine(CommonAppData, RepWebServer);
        }else{
            // DatabasePath := TPath.Combine(parentPath, DatabasePath);
            defaultPrefs.put(PREF_REP_IMAGES, new File(System.getProperty("user.dir"), PREF_REP_IMAGES));
            // RepScripts := TPath.Combine(parentPath, RepScripts);
            // RepWebServer := TPath.Combine(parentPath, RepWebServer);
        }

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

    public String getRepImages() {
        return getPrefs().getProperty(PREF_REP_IMAGES);
    }

    public void setRepImages(String value) {
        getPrefs().put(PREF_REP_IMAGES, value);
    }

}
