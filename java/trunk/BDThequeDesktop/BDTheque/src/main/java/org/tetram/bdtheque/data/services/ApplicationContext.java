/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ApplicationContext.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.services;

import java.io.File;

/**
 * Created by Thierry on 15/06/2014.
 */
public interface ApplicationContext {
    public String getUserDataDirectory();

    public File getUserConfigFile();
}
