/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BaseParaBD.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

/**
 * Created by Thierry on 11/07/2014.
 */

public abstract class BaseParaBD extends AbstractDBEntity {
    private final StringProperty titreParaBD = new AutoTrimStringProperty(this, "titreParaBD", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseParaBD.class;
    }

    public String getTitreParaBD() {
        return titreParaBD.get();
    }

    public void setTitreParaBD(String titreParaBD) {
        this.titreParaBD.set(titreParaBD);
    }

    public StringProperty titreParaBDProperty() {
        return titreParaBD;
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean avecSerie) {
        return buildLabel(false, avecSerie);
    }

    protected String buildLabel(boolean simple, boolean avecSerie) {
        String lb = getTitreParaBD();
        if (!simple)
            lb = BeanUtils.formatTitre(lb);
        return lb;
    }
}
