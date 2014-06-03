package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Serie extends AbstractDBEntity {
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
    private List<AuteurSerieLite> auteurs = new ArrayList<>();
    private List<AuteurSerieLite> scenaristes = null;
    private List<AuteurSerieLite> dessinateurs = null;
    private List<AuteurSerieLite> coloristes = null;
    private Boolean vo;
    private Boolean couleur;
    private ValeurListe etat;
    private ValeurListe reliure;
    private ValeurListe typeEdition;
    private ValeurListe formatEdition;
    private ValeurListe orientation;
    private ValeurListe sensLecture;
    private Integer notation;
    private List<UniversLite> univers = new ArrayList<>();

    public Serie() {
        ValeurListeDao valeurListeDao = Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class);
        etat = valeurListeDao.getDefaultEtat();
        reliure = valeurListeDao.getDefaultReliure();
        typeEdition = valeurListeDao.getDefaultTypeEdition();
        formatEdition = valeurListeDao.getDefaultFormatEdition();
        orientation = valeurListeDao.getDefaultOrientation();
        sensLecture = valeurListeDao.getDefaultSensLecture();
    }

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

    private void buildListsAuteurs() {
        int countScenaristes = (scenaristes != null ? scenaristes.size() : 0);
        int countDessinateurs = (dessinateurs != null ? dessinateurs.size() : 0);
        int countColoristes = (coloristes != null ? coloristes.size() : 0);

        int countAuteurs = countScenaristes + countDessinateurs + countColoristes;

        if (scenaristes == null || dessinateurs == null || coloristes == null || auteurs.size() != countAuteurs) {
            scenaristes = new ArrayList<>();
            dessinateurs = new ArrayList<>();
            coloristes = new ArrayList<>();
            for (AuteurSerieLite a : auteurs) {
                switch (a.getMetier()) {
                    case SCENARISTE:
                        scenaristes.add(a);
                        break;
                    case DESSINATEUR:
                        dessinateurs.add(a);
                        break;
                    case COLORISTE:
                        coloristes.add(a);
                        break;
                }
            }
        }
    }

    public List<AuteurSerieLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(List<AuteurSerieLite> auteurs) {
        this.auteurs = auteurs;
    }

    public List<AuteurSerieLite> getScenaristes() {
        buildListsAuteurs();
        return scenaristes;
    }

    public List<AuteurSerieLite> getDessinateurs() {
        buildListsAuteurs();
        return dessinateurs;
    }

    public List<AuteurSerieLite> getColoristes() {
        buildListsAuteurs();
        return coloristes;
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
