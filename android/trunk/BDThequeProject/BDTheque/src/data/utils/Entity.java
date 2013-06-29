package org.tetram.bdtheque.data.utils;

import org.tetram.bdtheque.data.factories.BeanFactory;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Inherited
public @interface Entity {
    String tableName();

    String primaryKey();

    Class<? extends BeanFactory> factoryClass();
}
