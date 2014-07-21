package org.tetram.bdtheque.data.services;

import com.sun.javafx.PlatformUtil;
import org.jetbrains.annotations.NonNls;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import java.io.File;

/**
 * Created by Thierry on 15/06/2014.
 */
@Service
@Lazy
@Scope

public class ApplicationContextImpl implements ApplicationContext {
    @NonNls
    private static final String CONFIG_FILE_NAME = "config.properties";

    public static void main(String... args) {
        System.getProperties().list(System.out);
    }

    @SuppressWarnings({"HardCodedStringLiteral", "StringConcatenation"})
    @Override
    public String getUserDataDirectory() {
        if (PlatformUtil.isWindows())
            return System.getenv("APPDATA") + "\\TetramCorp\\BDTheque";
        else
            return System.getProperty("user.home") + File.separator + ".tetramCorp" + File.separator + "bdtheque" + File.separator;
    }

    @Override
    public File getUserConfigFile() {
        File f = new File(System.getProperty("user.dir"), CONFIG_FILE_NAME);
        if (!f.exists())
            f = new File(getUserDataDirectory(), CONFIG_FILE_NAME);
        return f;
    }
}
