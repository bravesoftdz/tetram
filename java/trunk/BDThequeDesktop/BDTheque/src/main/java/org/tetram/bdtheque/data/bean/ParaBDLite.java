package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class ParaBDLite extends AbstractDBEntity {

    private StringProperty titre = new AutoTrimStringProperty(this, "titre", null);
    private ObjectProperty<UUID> idSerie = new SimpleObjectProperty<>(this, "idSerie", null);
    private StringProperty serie = new AutoTrimStringProperty(this, "serie", null);
    private StringProperty sCategorie = new AutoTrimStringProperty(this, "sCategorie", null);
    private BooleanProperty achat = new SimpleBooleanProperty(this, "achat", false);
    private BooleanProperty complet = new SimpleBooleanProperty(this, "complet", true);

    public String getTitre() {
        return titre.get();
    }

    public StringProperty titreProperty() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre.set(titre);
    }

    public UUID getIdSerie() {
        return idSerie.get();
    }

    public ObjectProperty<UUID> idSerieProperty() {
        return idSerie;
    }

    public void setIdSerie(UUID idSerie) {
        this.idSerie.set(idSerie);
    }

    public String getSerie() {
        return serie.get();
    }

    public StringProperty serieProperty() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie.set(serie);
    }

    public String getsCategorie() {
        return sCategorie.get();
    }

    public StringProperty sCategorieProperty() {
        return sCategorie;
    }

    public void setsCategorie(String sCategorie) {
        this.sCategorie.set(sCategorie);
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

    public BooleanProperty completProperty() {
        return complet;
    }

    public void setComplet(boolean complet) {
        this.complet.set(complet);
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean avecSerie) {
        return buildLabel(false, avecSerie);
    }

    private String buildLabel(boolean simple, boolean avecSerie) {
        String lb = getTitre();
        if (!simple)
            lb = BeanUtils.formatTitre(lb);
        String s = "";
        if (avecSerie)
            if ("".equals(lb))
                lb = BeanUtils.formatTitre(getSerie());
            else
                s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getSerie()), " - ");
        s = StringUtils.ajoutString(s, getsCategorie(), " - ");
        if ("".equals(lb))
            return s;
        else
            return StringUtils.ajoutString(lb, s, " ", "(", ")");

    }

}
