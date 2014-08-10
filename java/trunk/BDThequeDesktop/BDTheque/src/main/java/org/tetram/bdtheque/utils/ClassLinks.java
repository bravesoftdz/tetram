/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ClassLinks.java
 * Last modified by Thierry, on 2014-08-01T17:41:54CEST
 */

package org.tetram.bdtheque.utils;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Created by Thierry on 27/06/2014.
 */
@Retention(RetentionPolicy.CLASS)
public @interface ClassLinks {
    ClassLink[] value();
}
