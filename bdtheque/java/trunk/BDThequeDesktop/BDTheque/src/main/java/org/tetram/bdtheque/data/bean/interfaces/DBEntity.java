/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DBEntity.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ObjectProperty;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */

public interface DBEntity {

    default UUID getId() {
        return idProperty().get();
    }

    default void setId(UUID id) {
        idProperty().set(id);
    }

    ObjectProperty<UUID> idProperty();

}
