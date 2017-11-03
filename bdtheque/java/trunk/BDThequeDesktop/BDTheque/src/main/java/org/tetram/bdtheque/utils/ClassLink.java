/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ClassLink.java
 * Last modified by Tetram, on 2014-08-27T15:21:52CEST
 */

package org.tetram.bdtheque.utils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by Thierry on 27/06/2014.
 */
@Retention(RetentionPolicy.SOURCE)
public @interface ClassLink {
    Class<?> value();
}
