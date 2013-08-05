package org.tetram.bdtheque.data.orm.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Field {
    String fieldName() default "";

    boolean primaryKey() default false;

    boolean nullable() default true;
}
