/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLite.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import org.tetram.bdtheque.data.bean.abstractentities.BaseGenre;

/**
 * Created by Thierry on 24/05/2014.
 */

public class GenreLite extends BaseGenre {

    private final IntegerProperty quantite = new SimpleIntegerProperty(this, "quantite", 0);

    public int getQuantite() {
        return quantite.get();
    }

    public void setQuantite(int quantite) {
        this.quantite.set(quantite);
    }

    public IntegerProperty quantiteProperty() {
        return quantite;
    }

}
