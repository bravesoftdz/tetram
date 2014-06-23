package org.tetram.bdtheque.gui.utils;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 23/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class InitialEntity extends AbstractEntity {

    private IntegerProperty count = new SimpleIntegerProperty(this, "count", 0);
    private StringProperty value = new SimpleStringProperty(this, "value", "");
    private StringProperty label = new SimpleStringProperty(this, "label", "");

    private String unknownLabel = "";

    public int getCount() {
        return count.get();
    }

    public IntegerProperty countProperty() {
        return count;
    }

    public void setCount(int count) {
        this.count.set(count);
    }

    public String getValue() {
        return value.get();
    }

    public StringProperty valueProperty() {
        return value;
    }

    public void setValue(String value) {
        this.value.set(value);
    }

    public String getLabel() {
        return label.get();
    }

    public StringProperty labelProperty() {
        return label;
    }

    public void setLabel(String label) {
        this.label.set(label);
    }

    public String getUnknownLabel() {
        return unknownLabel;
    }

    public void setUnknownLabel(String unknownLabel) {
        this.unknownLabel = unknownLabel;
    }

    @Override
    public String buildLabel() {
        String label;
        if (getValue() != null)
            // chaque Dao doit s'occuper de la mise en forme du texte: elle dépend du type de l'objet
            // label = BeanUtils.formatTitre(value.getValueSafe());
            label = this.label.getValueSafe();
        else
/*
            case FMode of
              vmAlbumsSerie, vmAlbumsSerieUnivers, vmParaBDSerie, vmParaBDSerieUnivers:
                Text := '<Sans série>';
            else
              Text := '<Inconnu>';
            end
 */
            label = unknownLabel;
        return StringUtils.ajoutString(label, StringUtils.nonZero(getCount()), " ", "(", ")");
    }
}
