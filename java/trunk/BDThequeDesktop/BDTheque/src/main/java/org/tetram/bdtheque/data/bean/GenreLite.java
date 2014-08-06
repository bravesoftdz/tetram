/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLite.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseGenre;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.ScriptInfo;

/**
 * Created by Thierry on 24/05/2014.
 */

@ScriptInfo(typeData = 5)
public class GenreLite extends BaseGenre implements ScriptEntity {

    private final IntegerProperty quantite = new SimpleIntegerProperty(this, "quantite", 0);
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    public int getQuantite() {
        return quantite.get();
    }

    public void setQuantite(int quantite) {
        this.quantite.set(quantite);
    }

    public IntegerProperty quantiteProperty() {
        return quantite;
    }

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public String buildLabel() {
        return getNomGenre();
    }

}
