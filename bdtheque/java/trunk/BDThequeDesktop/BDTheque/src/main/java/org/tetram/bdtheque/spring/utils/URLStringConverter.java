/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * URLStringConverter.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.spring.utils;

import javafx.util.StringConverter;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by Thierry on 21/07/2014.
 */
public class URLStringConverter extends StringConverter<URL> {
    @Override
    public String toString(URL object) {
        return object == null ? "" : object.toString();
    }

    @Override
    public URL fromString(String string) {
        try {
            return new URL(string);
        } catch (MalformedURLException e) {
            // e.printStackTrace();
            return null;
        }
    }
}
