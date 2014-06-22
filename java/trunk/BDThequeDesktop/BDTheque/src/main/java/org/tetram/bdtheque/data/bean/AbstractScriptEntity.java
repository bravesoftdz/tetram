package org.tetram.bdtheque.data.bean;

import javafx.beans.property.SetProperty;
import javafx.beans.property.SimpleSetProperty;
import javafx.collections.FXCollections;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Thierry on 11/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractScriptEntity extends AbstractDBEntity implements ScriptEntity {

    private SetProperty<String> associations = new SimpleSetProperty<>(this, "associations", FXCollections.observableSet(new HashSet<>()));

    @Override
    public Set<String> getAssociations() {
        return associations.get();
    }

    @Override
    public void setAssociations(Set<String> associations) {
        this.associations.set(FXCollections.observableSet(associations));
    }

    public SetProperty<String> associationsProperty() {
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
