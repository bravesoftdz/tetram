package org.tetram.bdtheque.data.utils;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@Inherited
public @interface Field {
    static String DEFAULT_FIELDNAME = "** default field name **";

    String fieldName() default DEFAULT_FIELDNAME;
}
