/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FileLink.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.utils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by Thierry on 27/06/2014.
 */
@Retention(RetentionPolicy.CLASS)
public @interface FileLink {
    String value();
}
