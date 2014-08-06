/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * Main.java
 * Last modified by Tetram, on 2014-07-30T13:36:06CEST
 */

package org.tetram.bdtheque;
/**
 * Created by Thierry on 24/05/2014.
 */

import impl.org.controlsfx.i18n.Localization;
import javafx.application.Application;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import org.controlsfx.dialog.Dialogs;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.MainController;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.SpringFxmlLoader;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.logging.Log;
import org.tetram.bdtheque.utils.logging.LogManager;

import java.io.*;
import java.lang.reflect.Field;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Locale;

public class Main extends Application {

    @NonNls
    private static final String APPLICATION_TITLE = "BDTheque";
    @NonNls
    private static final String APPLICATION_ICON = "/org/tetram/bdtheque/graphics/png/128x128/bdtheque.png";

    @NonNls
    private static final String FB64_CLASSPATH = "firebird_x64";

    @NonNls
    private static final String FB32_CLASSPATH = "firebird_x86";

    private static Log log = LogManager.getLog(Main.class);

    static {
// 23/06/2014: peut être que ça servira un jour, quand FB Embedded n'imposera plus que les fichiers icu soit à la racine de l'appli
/*
        String fbPath = System.getProperty("user.dir") + File.separator;
        if (is64bitJVM())
            fbPath += FB64_CLASSPATH;
        else
            fbPath += FB32_CLASSPATH;

        updateLibraryPath(fbPath);
        updateFirebirdConf(fbPath);
*/
    }

    public static void main(String[] args) {
        Thread.setDefaultUncaughtExceptionHandler((t, e) -> {

            if (e instanceof ConsistencyException) {
                Dialogs.create().message(e.getMessage()).showWarning();
            } else if (e instanceof RuntimeException) {
                Dialogs.create().message(e.getLocalizedMessage()).showInformation();
            } else {
                log.error("", e);
                Dialogs.create().showException(e);
            }
        });
        launch(args);
    }

    public static void addLibraryPath(String pathToAdd) throws Exception {
        final Field usrPathsField = ClassLoader.class.getDeclaredField("usr_paths");
        usrPathsField.setAccessible(true);

        //get array of paths
        final String[] paths = (String[]) usrPathsField.get(null);

        //check if the path to add is already present
        for (String path : paths) {
            if (path.equals(pathToAdd)) {
                return;
            }
        }

        //add the new path
        final String[] newPaths = Arrays.copyOf(paths, paths.length + 1);
        newPaths[newPaths.length - 1] = pathToAdd;
        usrPathsField.set(null, newPaths);
    }

    static public boolean isFBLogged() {
        return Boolean.getBoolean("FBLog4j");
    }

    static public void setFBLogged(boolean value) {
        if (isFBLogged() != value)
            System.setProperty("FBLog4j", String.valueOf(value));
    }

    public static boolean is64bitJVM() {
        String property = System.getProperty("sun.arch.data.model");
        if (property == null)
            // 32bit VM: os.arch=x86
            // 64bit VM: os.arch=amd64
            property = System.getProperty("os.arch");

        return property.contains("64");
    }


    private static void updateLibraryPath(String fbPath) {
        try {
            addLibraryPath(fbPath);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private static void updateFirebirdConf(String fbPath) {
        File firebirdConfFile = new File(fbPath, "firebird.conf");
        @NonNls HashMap<String, String> firebirdConf = new HashMap<>();
        if (firebirdConfFile.exists()) {
            try {
                Files.lines(firebirdConfFile.toPath(), StandardCharsets.UTF_8).forEach(line -> {
                    int i = line.indexOf('=');
                    if (i == -1)
                        firebirdConf.put(line, "");
                    else
                        firebirdConf.put(line.substring(0, i), line.substring(i + 1));
                });
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        firebirdConf.put("RootDirectory", fbPath);
        OutputStream output = null;
        try {
            output = new FileOutputStream(firebirdConfFile, false);
            final OutputStream finalOutput = output;
            firebirdConf.forEach((key, value) -> {
                try {
                    String out = key;
                    if (!key.trim().startsWith("#"))
                        out += "=" + value;
                    finalOutput.write((out + "\n").getBytes());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });

        } catch (FileNotFoundException e) {
            e.printStackTrace();
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

    @Override
    public void start(Stage primaryStage) throws IOException {
        if (is64bitJVM()) {
            Dialogs.create()
                    .title(I18nSupport.message("erreur.de.chargement"))
                            //.masthead(I18nSupport.message("mauvaise.version.de.jvm"))
                    .message(I18nSupport.message("vous.devez.utiliser.la.version.32bits.de.la.jvm"))
                    .showError();
            return;
        }

        setFBLogged(true);
        final Locale locale = SpringContext.CONTEXT.getBean(UserPreferences.class).getLocale();
        I18nSupport.setLocale(locale);
        Localization.setLocale(locale);

        MainController mainController = SpringFxmlLoader.load("main.fxml", primaryStage);

        primaryStage.getIcons().add(new Image(getClass().getResourceAsStream(APPLICATION_ICON)));

        primaryStage.setTitle(APPLICATION_TITLE);
        primaryStage.setMaximized(true);
        Scene scene = new Scene((Parent) mainController.getView(), 1280, 800);
        primaryStage.setScene(scene);
        primaryStage.show();
        // ça dépanne mais c'est plein de petits bugs que j'ai pas envie de résoudre
        // SceneToolPlugin.load(primaryStage);
    }

}
