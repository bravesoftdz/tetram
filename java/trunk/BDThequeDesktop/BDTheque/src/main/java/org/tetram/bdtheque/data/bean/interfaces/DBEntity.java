package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ObjectProperty;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface DBEntity {

    default UUID getId() {
        return idProperty().get();
    }

    default void setId(UUID id) {
        idProperty().set(id);
    }

    ObjectProperty<UUID> idProperty();

}
