package org.tetram.bdtheque.spring.utils;

import javafx.beans.property.SimpleStringProperty;
import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.BeanUtils;

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
        super.set(BeanUtils.trimOrNull(newValue));
    }

    @Override
    public String get() {
        return BeanUtils.trimOrNull(super.get());
    }
}
