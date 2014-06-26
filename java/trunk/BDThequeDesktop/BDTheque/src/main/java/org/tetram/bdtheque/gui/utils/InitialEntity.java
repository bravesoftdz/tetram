package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 23/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class InitialEntity<T> extends AbstractEntity {

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
/*
            case FMode of
              vmAlbumsSerie, vmAlbumsSerieUnivers, vmParaBDSerie, vmParaBDSerieUnivers:
                Text := '<Sans série>';
            else
              Text := '<Inconnu>';
            end
 */
        return StringUtils.ajoutString(label.getValueSafe(), StringUtils.nonZero(getCount()), " ", "(", ")");
    }
}
