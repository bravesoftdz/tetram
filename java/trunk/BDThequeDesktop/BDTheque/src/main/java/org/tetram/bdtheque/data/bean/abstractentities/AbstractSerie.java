package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.EvaluatedEntity;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.WebLinkedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

import java.net.URL;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractSerie extends AbstractScriptEntity implements EvaluatedEntity, WebLinkedEntity {
    private final ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);
    private final StringProperty titreSerie = new SimpleStringProperty(this, "titreSerie", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

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
    public URL getSiteWeb() {
        return siteWeb.get();
    }

    @Override
    public void setSiteWeb(URL siteWeb) {
        this.siteWeb.set(siteWeb);
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    public ValeurListe getNotation() {
        return notation.get();
    }

    public void setNotation(ValeurListe notation) {
        this.notation.set(notation == null || notation.getValeur() == 0 ? SpringContext.CONTEXT.getBean(ValeurListeDao.class).getDefaultNotation() : notation);
    }

    public ObjectProperty<ValeurListe> notationProperty() {
        return notation;
    }
}
