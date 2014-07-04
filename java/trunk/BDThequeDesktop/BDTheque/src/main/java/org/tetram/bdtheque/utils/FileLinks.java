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
