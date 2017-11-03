/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AuteurParaBDLite.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAuteur;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

public class AuteurParaBDLite extends BaseAuteur {

    private final ObjectProperty<UUID> idParaBD = new SimpleObjectProperty<>(this, "idParaBD", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return AuteurParaBDLite.class;
    }


    public UUID getIdParaBD() {
        return idParaBD.get();
    }

    public void setIdParaBD(UUID idParaBD) {
        this.idParaBD.set(idParaBD);
    }

    public ObjectProperty<UUID> idParaBDProperty() {
        return idParaBD;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuteurParaBDLite)) return false;
        if (!super.equals(o)) return false;

        AuteurParaBDLite that = (AuteurParaBDLite) o;

        if (getIdParaBD() != null ? !getIdParaBD().equals(that.getIdParaBD()) : that.getIdParaBD() != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (getIdParaBD() != null ? getIdParaBD().hashCode() : 0);
        return result;
    }

    @Override
    public AbstractDBEntity lightRef() {
        AuteurParaBDLite e = (AuteurParaBDLite) super.lightRef();
        e.setIdParaBD(this.getIdParaBD());
        return e;
    }
}
