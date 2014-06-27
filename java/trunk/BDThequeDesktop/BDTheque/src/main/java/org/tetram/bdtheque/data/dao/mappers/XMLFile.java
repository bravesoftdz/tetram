package org.tetram.bdtheque.data.dao.mappers;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by Thierry on 27/06/2014.
 */
@Retention(RetentionPolicy.CLASS)
@Target(ElementType.TYPE)
public @interface XMLFile {
    String value();
}
