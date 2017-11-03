/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BaseUnivers.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;

/**
 * Created by Thierry on 11/07/2014.
 */

public abstract class BaseUnivers extends AbstractDBEntity implements WebLinkedEntity {
    private final StringProperty nomUnivers = new AutoTrimStringProperty(this, "nomUnivers", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseUnivers.class;
    }


    public String getNomUnivers() {
        return nomUnivers.get();
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers.set(nomUnivers);
    }

    public StringProperty nomUniversProperty() {
        return nomUnivers;
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomUnivers());
    }
}
