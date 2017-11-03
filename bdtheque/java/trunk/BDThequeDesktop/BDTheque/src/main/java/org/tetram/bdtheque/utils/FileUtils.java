/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FileUtils.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.utils;

import java.io.File;

/**
 * Created by Thierry on 14/06/2014.
 */
public class FileUtils extends org.apache.commons.io.FileUtils {
    public static boolean isNotNullAndExists(File fichier) {
        return fichier != null && fichier.exists();
    }
}
