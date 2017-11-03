/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * DefaultValeurListe.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;

/**
 * Created by Thierry on 28/05/2014.
 */

public class DefaultValeurListe {

    private final ObjectProperty<ValeurListe> valeur = new SimpleObjectProperty<>(this, "valeur", null);
    private final ObjectProperty<CategorieValeurListe> categorie = new SimpleObjectProperty<>(this, "categorie", CategorieValeurListe.NOT_USED);

    public ValeurListe getValeur() {
        return valeur.get();
    }

    public void setValeur(ValeurListe valeur) {
        this.valeur.set(valeur);
    }

    public ObjectProperty<ValeurListe> valeurProperty() {
        return valeur;
    }

    public CategorieValeurListe getCategorie() {
        return categorie.get();
    }

    public void setCategorie(CategorieValeurListe categorie) {
        this.categorie.set(categorie);
    }

    public ObjectProperty<CategorieValeurListe> categorieProperty() {
        return categorie;
    }
}
