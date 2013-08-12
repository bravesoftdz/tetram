package org.tetram.bdtheque.data.orm.annotations;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@SuppressWarnings("UnusedDeclaration")
@Retention(RetentionPolicy.RUNTIME)
public @interface Filter {
    String field();
    String value();
}
