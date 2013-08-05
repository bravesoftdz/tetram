package org.tetram.bdtheque.data.orm.annotations;

import org.tetram.bdtheque.data.dao.CommonDao;

import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.FIELD})
@Inherited
public @interface BeanDaoClass {
    Class<? extends CommonDao> value()/* default CommonDaoImpl.class*/;
}
