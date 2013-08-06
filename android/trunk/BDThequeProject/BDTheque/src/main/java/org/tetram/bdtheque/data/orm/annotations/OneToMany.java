package org.tetram.bdtheque.data.orm.annotations;

import org.tetram.bdtheque.data.orm.enums.FetchType;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@SuppressWarnings("UnusedDeclaration")
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface OneToMany {
    String mappedBy();

    boolean useFactory() default false;

    FetchType fetch() default FetchType.LAZY;

    java.lang.Class targetEntity() default void.class;
}
