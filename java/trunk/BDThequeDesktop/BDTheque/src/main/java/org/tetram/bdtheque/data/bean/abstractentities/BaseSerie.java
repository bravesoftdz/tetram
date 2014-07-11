package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

import java.net.URL;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class BaseSerie extends AbstractDBEntity implements EvaluatedEntity, WebLinkedEntity {
    private final StringProperty titreSerie = new SimpleStringProperty(this, "titreSerie", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);
    private final ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);

    static {
        baseClass = BaseSerie.class;
    }


    protected BaseSerie() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setNotation(valeurListeDao.getDefaultNotation());
    }

    public String getTitreSerie() {
        return BeanUtils.trimOrNull(titreSerie.get());
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie.set(BeanUtils.trimOrNull(titreSerie));
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
