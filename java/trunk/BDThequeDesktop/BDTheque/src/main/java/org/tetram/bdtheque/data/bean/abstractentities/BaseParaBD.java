package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.StringProperty;
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

    protected abstract String buildLabel(boolean simple, boolean avecSerie);
}
