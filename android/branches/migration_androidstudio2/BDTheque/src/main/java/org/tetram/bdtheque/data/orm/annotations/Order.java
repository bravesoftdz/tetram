package org.tetram.bdtheque.data.orm.annotations;

public @interface Order {
    String field();

    boolean asc() default true;
}
