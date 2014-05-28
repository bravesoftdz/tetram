package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.*;
import org.tetram.bdtheque.data.dao.DefaultValeurListeDao;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Serie extends DBEntity {
    private String titreSerie;

    private Boolean terminee;
    private List<GenreLite> genres = new ArrayList<>();
    private String sujet;
    private String notes;
    private Editeur editeur;
    private Collection collection;
    private URL siteWeb;
    private boolean complete;
    private boolean suivreManquants;
    private boolean suivreSorties;
    private int nbAlbums;
    private List<AlbumLite> albums = new ArrayList<>();
    private List<ParaBDLite> paraBDs = new ArrayList<>();
    private List<AuteurSerieLite> scenaristes = new ArrayList<>();
    private List<AuteurSerieLite> dessinateurs = new ArrayList<>();
    private List<AuteurSerieLite> coloristes = new ArrayList<>();
    private Boolean vo;
    private Boolean couleur;
    private ValeurListe etat = DefaultValeurListeDao.getInstance().getEtat();
    private ValeurListe reliure = DefaultValeurListeDao.getInstance().getReliure();
    private ValeurListe typeEdition = DefaultValeurListeDao.getInstance().getTypeEdition();
    private ValeurListe formatEdition = DefaultValeurListeDao.getInstance().getFormatEdition();
    private ValeurListe orientation = DefaultValeurListeDao.getInstance().getOrientation();
    private ValeurListe sensLecture = DefaultValeurListeDao.getInstance().getSensLecture();
    private Integer notation;
    private List<UniversLite> univers = new ArrayList<>();

    public String getTitreSerie() {
        return titreSerie;
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie = titreSerie;
    }

    public Boolean getTerminee() {
        return terminee;
    }

    public void setTerminee(Boolean terminee) {
        this.terminee = terminee;
    }

    public List<GenreLite> getGenres() {
        return genres;
    }

    public void setGenres(List<GenreLite> genres) {
        this.genres = genres;
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

    public Editeur getEditeur() {
        return editeur;
    }

    public void setEditeur(Editeur editeur) {
        this.editeur = editeur;
    }

    public Collection getCollection() {
        return collection;
    }

    public void setCollection(Collection collection) {
        this.collection = collection;
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public boolean isComplete() {
        return complete;
    }

    public void setComplete(boolean complete) {
        this.complete = complete;
    }

    public boolean isSuivreManquants() {
        return suivreManquants;
    }

    public void setSuivreManquants(boolean suivreManquants) {
        this.suivreManquants = suivreManquants;
    }

    public boolean isSuivreSorties() {
        return suivreSorties;
    }

    public void setSuivreSorties(boolean suivreSorties) {
        this.suivreSorties = suivreSorties;
    }

    public int getNbAlbums() {
        return nbAlbums;
    }

    public void setNbAlbums(int nbAlbums) {
        this.nbAlbums = nbAlbums;
    }

    public List<AlbumLite> getAlbums() {
        return albums;
    }

    public void setAlbums(List<AlbumLite> albums) {
        this.albums = albums;
    }

    public List<ParaBDLite> getParaBDs() {
        return paraBDs;
    }

    public void setParaBDs(List<ParaBDLite> paraBDs) {
        this.paraBDs = paraBDs;
    }

    public List<AuteurSerieLite> getScenaristes() {
        return scenaristes;
    }

    public void setScenaristes(List<AuteurSerieLite> scenaristes) {
        this.scenaristes = scenaristes;
    }

    public List<AuteurSerieLite> getDessinateurs() {
        return dessinateurs;
    }

    public void setDessinateurs(List<AuteurSerieLite> dessinateurs) {
        this.dessinateurs = dessinateurs;
    }

    public List<AuteurSerieLite> getColoristes() {
        return coloristes;
    }

    public void setColoristes(List<AuteurSerieLite> coloristes) {
        this.coloristes = coloristes;
    }

    public Boolean getVo() {
        return vo;
    }

    public void setVo(Boolean vo) {
        this.vo = vo;
    }

    public Boolean getCouleur() {
        return couleur;
    }

    public void setCouleur(Boolean couleur) {
        this.couleur = couleur;
    }

    public Integer getNotation() {
        return notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation == 0 ? 900 : notation;
    }

    public List<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers = univers;
    }

    public UUID getIdEditeur() {
        return editeur.getId();
    }

    public UUID getIdCollection() {
        return collection.getId();
    }

    public ValeurListe getEtat() {
        return etat;
    }

    public void setEtat(ValeurListe etat) {
        this.etat = etat;
    }

    public ValeurListe getReliure() {
        return reliure;
    }

    public void setReliure(ValeurListe reliure) {
        this.reliure = reliure;
    }

    public ValeurListe getTypeEdition() {
        return typeEdition;
    }

    public void setTypeEdition(ValeurListe typeEdition) {
        this.typeEdition = typeEdition;
    }

    public ValeurListe getFormatEdition() {
        return formatEdition;
    }

    public void setFormatEdition(ValeurListe formatEdition) {
        this.formatEdition = formatEdition;
    }

    public ValeurListe getOrientation() {
        return orientation;
    }

    public void setOrientation(ValeurListe orientation) {
        this.orientation = orientation;
    }

    public ValeurListe getSensLecture() {
        return sensLecture;
    }

    public void setSensLecture(ValeurListe sensLecture) {
        this.sensLecture = sensLecture;
    }
}
