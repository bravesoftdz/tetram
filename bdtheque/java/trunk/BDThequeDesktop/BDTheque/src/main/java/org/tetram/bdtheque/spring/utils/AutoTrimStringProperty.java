/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AutoTrimStringProperty.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.spring.utils;

import javafx.beans.property.SimpleStringProperty;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 01/07/2014.
 */
public class AutoTrimStringProperty extends SimpleStringProperty {

    public AutoTrimStringProperty() {
        super();
    }

    public AutoTrimStringProperty(String initialValue) {
        super(initialValue);
    }

    public AutoTrimStringProperty(Object bean, @NonNls String name) {
        super(bean, name);
    }

    public AutoTrimStringProperty(Object bean, @NonNls String name, String initialValue) {
        super(bean, name, initialValue);
    }

    @Override
    public void set(String newValue) {
        super.set(StringUtils.trim(newValue));
    }

    @Override
    public String get() {
        return StringUtils.trim(super.get());
    }
}
