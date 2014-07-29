/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * InitialeEntity.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;

/**
 * Created by Thierry on 23/06/2014.
 */

public class InitialeEntity<T> extends AbstractEntity {

    private final IntegerProperty count = new SimpleIntegerProperty(this, "count", 0);
    private final ObjectProperty<T> value = new SimpleObjectProperty<>(this, "value", null);
    private final StringProperty label = new SimpleStringProperty(this, "label", "");

    public int getCount() {
        return count.get();
    }

    public void setCount(int count) {
        this.count.set(count);
    }

    public IntegerProperty countProperty() {
        return count;
    }

    public T getValue() {
        return value.get();
    }

    public void setValue(T value) {
        this.value.set(value);
    }

    public ObjectProperty<T> valueProperty() {
        return value;
    }

    public String getLabel() {
        return label.get();
    }

    public void setLabel(String label) {
        this.label.set(label);
    }

    public StringProperty labelProperty() {
        return label;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof InitialeEntity)) return false;

        InitialeEntity that = (InitialeEntity) o;

        if (getValue() != null ? !getValue().equals(that.value) : that.getValue() != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return getValue() != null ? getValue().hashCode() : 0;
    }

    @Override
    public String buildLabel() {
        // return StringUtils.ajoutString(label.getValueSafe(), StringUtils.nonZero(getCount()), " ", "(", ")");
        return label.getValueSafe();
    }

/*
    @Override
    public int compareTo(@NotNull InitialeEntity<T> o) {
        if (this == o) return 0;

        return getValue().compareTo(o.getValue());
    }
*/
}
