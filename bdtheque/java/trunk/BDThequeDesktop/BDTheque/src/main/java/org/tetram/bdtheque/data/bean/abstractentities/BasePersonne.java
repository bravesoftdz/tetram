/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BasePersonne.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.PersonneLite;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;
import java.util.Comparator;

/**
 * Created by Thierry on 10/07/2014.
 */

public abstract class BasePersonne extends AbstractDBEntity implements WebLinkedEntity {
    public final static Comparator<PersonneLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomPersonne(), o2.getNomPersonne());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomPersonne = new AutoTrimStringProperty(this, "nomPersonne", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BasePersonne.class;
    }


    public String getNomPersonne() {
        return nomPersonne.get();
    }

    public void setNomPersonne(String nomPersonne) {
        this.nomPersonne.set(nomPersonne);
    }

    public StringProperty nomPersonneProperty() {
        return nomPersonne;
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomPersonne());
    }
}
