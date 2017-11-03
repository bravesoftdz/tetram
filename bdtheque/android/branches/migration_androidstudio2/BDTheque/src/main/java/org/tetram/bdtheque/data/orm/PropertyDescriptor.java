package org.tetram.bdtheque.data.orm;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class PropertyDescriptor {
    Field field;
    Method setter;
    Method getter;

    public Field getField() {
        return this.field;
    }

    public Method getGetter() {
        return this.getter;
    }

    public Method getSetter() {
        return this.setter;
    }

}
