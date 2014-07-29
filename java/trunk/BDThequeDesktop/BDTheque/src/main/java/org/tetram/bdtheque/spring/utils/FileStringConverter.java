/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FileStringConverter.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.spring.utils;

import javafx.util.StringConverter;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.File;

/**
 * Created by Thierry on 02/07/2014.
 */
public class FileStringConverter extends StringConverter<File> {
    @Override
    public String toString(File object) {
        return object == null ? null : StringUtils.notNull(object.getAbsolutePath());
    }

    @Override
    public File fromString(String string) {
        return StringUtils.isNullOrEmpty(string) ? null : new File(string);
    }
}
