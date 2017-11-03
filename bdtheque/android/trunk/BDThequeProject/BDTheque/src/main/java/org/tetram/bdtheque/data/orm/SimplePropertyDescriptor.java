package org.tetram.bdtheque.data.orm;

import org.tetram.bdtheque.data.orm.annotations.Field;

public class SimplePropertyDescriptor extends PropertyDescriptor {
    Field annotation;
    String dbFieldName;

    public Field getAnnotation() {
        return this.annotation;
    }

    public String getDbFieldName() {
        return this.dbFieldName;
    }
}
