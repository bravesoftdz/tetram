package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

public class ParaBDLite extends BaseParaBD {

    private final ObjectProperty<UUID> idSerie = new SimpleObjectProperty<>(this, "idSerie", null);
    private final StringProperty titreSerie = new AutoTrimStringProperty(this, "titreSerie", null);
    private final StringProperty sCategorie = new AutoTrimStringProperty(this, "sCategorie", null);
    private final BooleanProperty achat = new SimpleBooleanProperty(this, "achat", false);
    private final BooleanProperty complet = new SimpleBooleanProperty(this, "complet", true);

    public UUID getIdSerie() {
        return idSerie.get();
    }

    public void setIdSerie(UUID idSerie) {
        this.idSerie.set(idSerie);
    }

    public ObjectProperty<UUID> idSerieProperty() {
        return idSerie;
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

    public String getsCategorie() {
        return sCategorie.get();
    }

    public void setsCategorie(String sCategorie) {
        this.sCategorie.set(sCategorie);
    }

    public StringProperty sCategorieProperty() {
        return sCategorie;
    }

    public boolean isAchat() {
        return achat.get();
    }

    public void setAchat(boolean achat) {
        this.achat.set(achat);
    }

    public BooleanProperty achatProperty() {
        return achat;
    }

    public boolean isComplet() {
        return complet.get();
    }

    public void setComplet(boolean complet) {
        this.complet.set(complet);
    }

    public BooleanProperty completProperty() {
        return complet;
    }

    @Override
    protected String buildLabel(boolean simple, boolean avecSerie) {
        String lb = super.buildLabel(simple, avecSerie);
        String s = "";
        if (avecSerie)
            if ("".equals(lb))
                lb = BeanUtils.formatTitre(getTitreSerie());
            else
                s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getTitreSerie()), " - ");
        s = StringUtils.ajoutString(s, getsCategorie(), " - ");
        if ("".equals(lb))
            return s;
        else
            return StringUtils.ajoutString(lb, s, " ", "(", ")");

    }

}
