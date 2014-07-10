package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface DBEntity {

    UUID getId();

    void setId(UUID id);

    ObjectProperty<UUID> idProperty();

}
