/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * CallbackDefault.java
 * Last modified by Thierry, on 2014-10-30T19:25:03CET
 */

package org.tetram.bdtheque.utils;

/**
 * Created by Tetram on 30/10/2014.
 */
@FunctionalInterface
public interface CallbackDefault<P,R> {
    public R call(P param, R defaultValue);
}
