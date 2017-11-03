/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * Editeur.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseEditeur;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.ScriptInfo;

/**
 * Created by Thierry on 24/05/2014.
 */
@ScriptInfo(typeData = 3)
public class Editeur extends BaseEditeur implements ScriptEntity {

    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

}
