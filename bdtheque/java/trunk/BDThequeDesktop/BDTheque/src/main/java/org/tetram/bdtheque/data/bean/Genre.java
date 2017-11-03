/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * Genre.java
 * Last modified by Thierry, on 2014-08-06T15:41:37CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseGenre;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.ScriptInfo;

/**
 * Created by Thierry on 24/05/2014.
 */

@ScriptInfo(typeData = 5)
public class Genre extends BaseGenre implements ScriptEntity {

    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public String buildLabel() {
        return getNomGenre();
    }

}
