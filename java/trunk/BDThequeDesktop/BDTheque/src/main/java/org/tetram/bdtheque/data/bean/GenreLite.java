/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * GenreLite.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */

@DaoScriptImpl.ScriptInfo(typeData = 5)
public class GenreLite extends AbstractDBEntity implements ScriptEntity {

    public static Comparator<GenreLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomGenre(), o2.getNomGenre());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomGenre = new AutoTrimStringProperty(this, "genre", null);
    private final IntegerProperty quantite = new SimpleIntegerProperty(this, "quantite", 0);
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return GenreLite.class;
    }


    public String getNomGenre() {
        return nomGenre.get();
    }

    public void setNomGenre(String nomGenre) {
        this.nomGenre.set(nomGenre);
    }

    public StringProperty nomGenreProperty() {
        return nomGenre;
    }

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
