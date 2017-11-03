/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ScriptInfo.java
 * Last modified by Thierry, on 2014-08-06T12:25:22CEST
 */

package org.tetram.bdtheque.data.dao;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by Thierry on 12/06/2014.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface ScriptInfo {
    int typeData();

    String getParentIdMethod() default "";
}
