package org.tetram.bdtheque.data.bean.lite;

import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AlbumLite extends DBEntityLite {
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private String titre;
    private UUID idSerie;
    private String serie;
    private UUID idEditeur;
    private String editeur;
    private Integer anneeParution, moisParution;
    private boolean stock;
    private boolean integrale;
    private boolean horsSerie;
    private boolean achat;
    private boolean complet = true;
    private Integer notation;

    public Integer getTome() {
        return tome;
    }

    public void setTome(Integer tome) {
        this.tome = tome;
    }

    public Integer getTomeDebut() {
        return tomeDebut;
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut = tomeDebut;
    }

    public Integer getTomeFin() {
        return tomeFin;
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin = tomeFin;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public UUID getIdSerie() {
        return idSerie;
    }

    public void setIdSerie(UUID idSerie) {
        this.idSerie = idSerie;
    }

    public String getSerie() {
        return serie;
    }

    public void setSerie(String serie) {
        this.serie = serie;
    }

    public UUID getIdEditeur() {
        return idEditeur;
    }

    public void setIdEditeur(UUID idEditeur) {
        this.idEditeur = idEditeur;
    }

    public String getEditeur() {
        return editeur;
    }

    public void setEditeur(String editeur) {
        this.editeur = editeur;
    }

    public Integer getAnneeParution() {
        return anneeParution;
    }

    public void setAnneeParution(Integer anneeParution) {
        this.anneeParution = anneeParution;
    }

    public Integer getMoisParution() {
        return moisParution;
    }

    public void setMoisParution(Integer moisParution) {
        this.moisParution = moisParution;
    }

    public boolean isStock() {
        return stock;
    }

    public void setStock(boolean stock) {
        this.stock = stock;
    }

    public boolean isIntegrale() {
        return integrale;
    }

    public void setIntegrale(boolean integrale) {
        this.integrale = integrale;
    }

    public boolean isHorsSerie() {
        return horsSerie;
    }

    public void setHorsSerie(boolean horsSerie) {
        this.horsSerie = horsSerie;
    }

    public boolean isAchat() {
        return achat;
    }

    public void setAchat(boolean achat) {
        this.achat = achat;
    }

    public boolean isComplet() {
        return complet;
    }

    public void setComplet(boolean complet) {
        this.complet = complet;
    }

    public Integer getNotation() {
        return notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation == 0 ? 900 : notation;
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean avecSerie) {
        return buildLabel(false, avecSerie);
    }

    public String buildLabel(boolean simple, boolean avecSerie) {
        return StringUtils.formatTitreAlbum(simple, avecSerie, titre, serie, tome, tomeDebut, tomeFin, integrale, horsSerie);
    }

}
