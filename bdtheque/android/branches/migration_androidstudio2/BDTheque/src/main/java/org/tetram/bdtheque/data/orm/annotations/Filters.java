package org.tetram.bdtheque.data.orm.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@SuppressWarnings("UnusedDeclaration")
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Filters {
    Filter[] value();
}
