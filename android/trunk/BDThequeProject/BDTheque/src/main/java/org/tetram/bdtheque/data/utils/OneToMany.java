package org.tetram.bdtheque.data.utils;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface OneToMany {
    String mappedBy();
    String orderBy() default "";
    FetchType fetch() default FetchType.LAZY;
    java.lang.Class	targetEntity() default void.class;
}
