/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FileLinks.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.utils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by Thierry on 27/06/2014.
 */
@Retention(RetentionPolicy.CLASS)
public @interface FileLinks {
    FileLink[] value();
}
