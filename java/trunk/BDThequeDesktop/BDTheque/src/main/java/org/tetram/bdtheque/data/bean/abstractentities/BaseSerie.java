package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.data.bean.SerieLite;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;
import java.util.Comparator;

/**
 * Created by Thierry on 10/07/2014.
 */

public abstract class BaseSerie extends AbstractDBEntity implements EvaluatedEntity, WebLinkedEntity {
    public static Comparator<SerieLite> DEFAULT_COMPARATOR = new Comparator<SerieLite>() {
        @Override
        public int compare(SerieLite o1, SerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getTitreSerie(), o2.getTitreSerie());
            if (comparaison != 0) return comparaison;

            comparaison = EditeurLite.DEFAULT_COMPARATOR.compare(o1.getEditeur(), o2.getEditeur());
            if (comparaison != 0) return comparaison;

            comparaison = CollectionLite.DEFAULT_COMPARATOR.compare(o1.getCollection(), o2.getCollection());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
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
