package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.ScriptEntity;

import java.util.List;

/**
 * Created by Thierry on 11/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractScriptEntity extends AbstractDBEntity implements ScriptEntity {

    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public List<String> getAssociations() {
        return associations.get();
    }

    @Override
    public void setAssociations(List<String> associations) {
        this.associations.set(FXCollections.observableList(associations));
    }

    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public boolean addAssociation(String association) {
        return associations.add(association);
    }

    @Override
    public boolean removeAssociation(String association) {
        return associations.remove(association);
    }

}
