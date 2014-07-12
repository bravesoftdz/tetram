package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;

/**
 * Created by Thierry on 23/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class InitialeEntity<T> extends AbstractEntity {

    private IntegerProperty count = new SimpleIntegerProperty(this, "count", 0);
    private ObjectProperty<T> value = new SimpleObjectProperty<>(this, "value", null);
    private StringProperty label = new SimpleStringProperty(this, "label", "");

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
    public String buildLabel() {
        // return StringUtils.ajoutString(label.getValueSafe(), StringUtils.nonZero(getCount()), " ", "(", ")");
        return label.getValueSafe();
    }

}
