package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.data.dao.ValeurListeDaoImpl;

import java.net.URL;
import java.util.*;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Serie extends AbstractScriptEntity {
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
    private Set<AuteurSerieLite> auteurs = new HashSet<>();
    private Set<AuteurSerieLite> scenaristes = null;
    private Set<AuteurSerieLite> dessinateurs = null;
    private Set<AuteurSerieLite> coloristes = null;
    private Boolean vo;
    private Boolean couleur;
    private ValeurListe etat;
    private ValeurListe reliure;
    private ValeurListe typeEdition;
    private ValeurListe formatEdition;
    private ValeurListe orientation;
    private ValeurListe sensLecture;
    private ValeurListe notation;
    private Set<UniversLite> univers = new HashSet<>();

    public Serie() {
        ValeurListeDao valeurListeDao = Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class);
        etat = valeurListeDao.getDefaultEtat();
        reliure = valeurListeDao.getDefaultReliure();
        typeEdition = valeurListeDao.getDefaultTypeEdition();
        formatEdition = valeurListeDao.getDefaultFormatEdition();
        orientation = valeurListeDao.getDefaultOrientation();
        sensLecture = valeurListeDao.getDefaultSensLecture();
        notation = valeurListeDao.getDefaultNotation();
    }

    public String getTitreSerie() {
        return BeanUtils.trim(titreSerie);
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie = BeanUtils.trim(titreSerie);
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
        return BeanUtils.trim(sujet);
    }

    public void setSujet(String sujet) {
        this.sujet = BeanUtils.trim(sujet);
    }

    public String getNotes() {
        return BeanUtils.trim(notes);
    }

    public void setNotes(String notes) {
        this.notes = BeanUtils.trim(notes);
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
            scenaristes = new HashSet<>();
            dessinateurs = new HashSet<>();
            coloristes = new HashSet<>();
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

    public Set<AuteurSerieLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(Set<AuteurSerieLite> auteurs) {
        this.auteurs = auteurs;
    }

    private boolean addAuteur(PersonneLite personne, Set<AuteurSerieLite> listAuteurs, MetierAuteur metier) {
        for (AuteurSerieLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) return false;
        AuteurSerieLite auteur = new AuteurSerieLite();
        auteur.setPersonne(personne);
        auteur.setMetier(metier);
        listAuteurs.add(auteur);
        auteurs.add(auteur);
        return true;
    }

    public boolean addScenariste(PersonneLite personne) {
        return addAuteur(personne, getScenaristes(), MetierAuteur.SCENARISTE);
    }

    public boolean addDessinateur(PersonneLite personne) {
        return addAuteur(personne, getDessinateurs(), MetierAuteur.DESSINATEUR);
    }

    public boolean addColoriste(PersonneLite personne) {
        return addAuteur(personne, getColoristes(), MetierAuteur.COLORISTE);
    }

    private boolean removeAuteur(PersonneLite personne, Set<AuteurSerieLite> listAuteurs) {
        for (AuteurSerieLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) {
                listAuteurs.remove(auteur);
                auteurs.remove(auteur);
                return true;
            }
        return false;
    }

    public boolean removeScenariste(PersonneLite personne) {
        return removeAuteur(personne, getScenaristes());
    }

    public boolean removeDessinateur(PersonneLite personne) {
        return removeAuteur(personne, getDessinateurs());
    }

    public boolean removeColoriste(PersonneLite personne) {
        return removeAuteur(personne, getColoristes());
    }

    public Set<AuteurSerieLite> getScenaristes() {
        buildListsAuteurs();
        return scenaristes;
    }

    public Set<AuteurSerieLite> getDessinateurs() {
        buildListsAuteurs();
        return dessinateurs;
    }

    public Set<AuteurSerieLite> getColoristes() {
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

    public ValeurListe getNotation() {
        return notation;
    }

    public void setNotation(ValeurListe notation) {
        this.notation = notation == null || notation.getValeur() == 0 ? Database.getInstance().getApplicationContext().getBean(ValeurListeDaoImpl.class).getDefaultNotation() : notation;
    }

    public Set<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(Set<UniversLite> univers) {
        this.univers = univers;
    }

    @SuppressWarnings("SimplifiableIfStatement")
    public boolean addUnivers(UniversLite universLite) {
        if (!getUnivers().contains(universLite))
            return univers.add(universLite);
        return false;
    }

    public boolean removeUnivers(UniversLite universLite) {
        return getUnivers().remove(universLite);
    }

    public UUID getIdEditeur() {
        return getEditeur().getId();
    }

    public UUID getIdCollection() {
        return getCollection().getId();
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
