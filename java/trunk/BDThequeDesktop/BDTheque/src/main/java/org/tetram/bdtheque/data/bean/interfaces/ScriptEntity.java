package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ListProperty;
import javafx.collections.FXCollections;

import java.util.List;

/**
 * Created by Thierry on 11/06/2014.
 */

public interface ScriptEntity extends DBEntity {

    default List<String> getAssociations() {
        return associationsProperty().get();
    }

    default void setAssociations(List<String> associations) {
        associationsProperty().set(FXCollections.observableList(associations));
    }

    ListProperty<String> associationsProperty();

    default boolean addAssociation(String association) {
        return associationsProperty().add(association);
    }

    default boolean removeAssociation(String association) {
        return associationsProperty().remove(association);
    }

}
