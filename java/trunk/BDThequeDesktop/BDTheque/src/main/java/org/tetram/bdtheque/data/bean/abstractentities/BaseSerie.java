package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;

/**
 * Created by Thierry on 10/07/2014.
 */

public abstract class BaseSerie extends AbstractDBEntity implements EvaluatedEntity, WebLinkedEntity {
    private final StringProperty titreSerie = new AutoTrimStringProperty(this, "titreSerie", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);
    private final ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);

    protected BaseSerie() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setNotation(valeurListeDao.getDefaultNotation());
    }

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseSerie.class;
    }

    public String getTitreSerie() {
        return titreSerie.get();
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie.set(titreSerie);
    }

    public StringProperty titreSerieProperty() {
        return titreSerie;
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public ObjectProperty<ValeurListe> notationProperty() {
        return notation;
    }
}
