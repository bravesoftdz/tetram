package org.tetram.bdtheque.data.services;

import java.io.File;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface ApplicationContext {
    public String getUserDataDirectory();

    public File getUserConfigFile();
}
