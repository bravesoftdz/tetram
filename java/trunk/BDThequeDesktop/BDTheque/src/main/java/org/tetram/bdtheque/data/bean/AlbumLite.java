package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

public class AlbumLite extends BaseAlbum {

    private final ObjectProperty<UUID> idSerie = new SimpleObjectProperty<>(this, "idSerie", null);
    private final StringProperty titreSerie = new AutoTrimStringProperty(this, "titreSerie", "");
    private final ObjectProperty<UUID> idEditeur = new SimpleObjectProperty<>(this, "idEditeur", null);
    private final StringProperty editeur = new AutoTrimStringProperty(this, "serie", "");
    private final BooleanProperty stock = new SimpleBooleanProperty(this, "stock", true);
    private final BooleanProperty achat = new SimpleBooleanProperty(this, "achat", true);

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

    public UUID getIdEditeur() {
        return idEditeur.get();
    }

    public void setIdEditeur(UUID idEditeur) {
        this.idEditeur.set(idEditeur);
    }

    public ObjectProperty<UUID> idEditeurProperty() {
        return idEditeur;
    }

    public String getEditeur() {
        return editeur.get();
    }

    public void setEditeur(String editeur) {
        this.editeur.set(editeur);
    }

    public StringProperty editeurProperty() {
        return editeur;
    }

    public boolean isStock() {
        return stock.get();
    }

    public void setStock(boolean stock) {
        this.stock.set(stock);
    }

    public BooleanProperty stockProperty() {
        return stock;
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

    @Override
    public String buildLabel(boolean simple, boolean avecSerie) {
        return BeanUtils.formatTitreAlbum(simple, avecSerie, getTitreAlbum(), getTitreSerie(), getTome(), getTomeDebut(), getTomeFin(), isIntegrale(), isHorsSerie());
    }

}
