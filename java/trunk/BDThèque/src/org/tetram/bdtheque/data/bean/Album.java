package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.lite.UniversLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Album extends DBEntity {
    private boolean complet;
    private String titreAlbum;
    private Serie serie;
    private Integer moisParution, anneeParution;
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private boolean horsSerie;
    private boolean integrale;
    private List<AuteurAlbumLite> scenaristes;
    private List<AuteurAlbumLite> dessinateurs;
    private List<AuteurAlbumLite> coloristes;
    private String sujet;
    private String notes;
    private List<Edition> editions;
    private Integer notation;
    private List<UniversLite> univers;
    private List<UniversLite> universFull;

    public boolean isComplet() {
        return complet;
    }

    public void setComplet(boolean complet) {
        this.complet = complet;
    }

    public String getTitreAlbum() {
        return titreAlbum;
    }

    public void setTitreAlbum(String titreAlbum) {
        this.titreAlbum = titreAlbum;
    }

    public Serie getSerie() {
        return serie;
    }

    public void setSerie(Serie serie) {
        this.serie = serie;
    }

    public Integer getMoisParution() {
        return moisParution;
    }

    public void setMoisParution(Integer moisParution) {
        this.moisParution = moisParution;
    }

    public Integer getAnneeParution() {
        return anneeParution;
    }

    public void setAnneeParution(Integer anneeParution) {
        this.anneeParution = anneeParution;
    }

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

    public boolean isHorsSerie() {
        return horsSerie;
    }

    public void setHorsSerie(boolean horsSerie) {
        this.horsSerie = horsSerie;
    }

    public boolean isIntegrale() {
        return integrale;
    }

    public void setIntegrale(boolean integrale) {
        this.integrale = integrale;
    }

    public List<AuteurAlbumLite> getScenaristes() {
        return scenaristes;
    }

    public void setScenaristes(List<AuteurAlbumLite> scenaristes) {
        this.scenaristes = scenaristes;
    }

    public List<AuteurAlbumLite> getDessinateurs() {
        return dessinateurs;
    }

    public void setDessinateurs(List<AuteurAlbumLite> dessinateurs) {
        this.dessinateurs = dessinateurs;
    }

    public List<AuteurAlbumLite> getColoristes() {
        return coloristes;
    }

    public void setColoristes(List<AuteurAlbumLite> coloristes) {
        this.coloristes = coloristes;
    }

    public String getSujet() {
        return sujet;
    }

    public void setSujet(String sujet) {
        this.sujet = sujet;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<Edition> getEditions() {
        return editions;
    }

    public void setEditions(List<Edition> editions) {
        this.editions = editions;
    }

    public Integer getNotation() {
        return notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation;
    }

    public List<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers = univers;
    }

    public List<UniversLite> getUniversFull() {
        return universFull;
    }

    public void setUniversFull(List<UniversLite> universFull) {
        this.universFull = universFull;
    }

    public UUID getIdSerie() {
        return serie.getId();
    }

}
