package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 7)
public class Serie extends AbstractScriptEntity implements EvaluatedEntity, WebLinkedEntity {

    private StringProperty titreSerie = new SimpleStringProperty(this, "titreSerie", null);
    private ObjectProperty<Boolean> terminee = new SimpleObjectProperty<>(this, "terminee", null);
    private ListProperty<GenreLite> genres = new SimpleListProperty<>(this, "genres", FXCollections.<GenreLite>observableList(new ArrayList<>()));
    private StringProperty sujet = new SimpleStringProperty(this, "sujet", null);
    private StringProperty notes = new SimpleStringProperty(this, "notes", null);
    private ObjectProperty<EditeurLite> editeur = new SimpleObjectProperty<>(this, "editeur", null);
    private ObjectProperty<CollectionLite> collection = new SimpleObjectProperty<>(this, "collection", null);
    private ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);
    private BooleanProperty complete = new SimpleBooleanProperty(this, "complete", false);
    private BooleanProperty suivreManquants = new SimpleBooleanProperty(this, "suivreManquants", false);
    private BooleanProperty suivreSorties = new SimpleBooleanProperty(this, "suivreSorties", false);
    private IntegerProperty nbAlbums = new SimpleIntegerProperty(this, "nbAlbums", 0);
    private ListProperty<AlbumLite> albums = new SimpleListProperty<>(this, "albums", FXCollections.<AlbumLite>observableList(new ArrayList<>()));
    private ListProperty<ParaBDLite> paraBDs = new SimpleListProperty<>(this, "paraBDs", FXCollections.<ParaBDLite>observableList(new ArrayList<>()));
    private ListProperty<AuteurSerieLite> auteurs = new SimpleListProperty<>(this, "auteurs", FXCollections.<AuteurSerieLite>observableList(new ArrayList<>()));
    private ListProperty<AuteurSerieLite> scenaristes = new SimpleListProperty<>(this, "scenaristes", FXCollections.<AuteurSerieLite>observableList(new ArrayList<>()));
    private ListProperty<AuteurSerieLite> dessinateurs = new SimpleListProperty<>(this, "dessinateurs", FXCollections.<AuteurSerieLite>observableList(new ArrayList<>()));
    private ListProperty<AuteurSerieLite> coloristes = new SimpleListProperty<>(this, "coloristes", FXCollections.<AuteurSerieLite>observableList(new ArrayList<>()));
    private ObjectProperty<Boolean> vo = new SimpleObjectProperty<>(this, "vo", null);
    private ObjectProperty<Boolean> couleur = new SimpleObjectProperty<>(this, "couleur", null);
    private ObjectProperty<ValeurListe> etat = new SimpleObjectProperty<>(this, "etat", null);
    private ObjectProperty<ValeurListe> reliure = new SimpleObjectProperty<>(this, "reliure", null);
    private ObjectProperty<ValeurListe> typeEdition = new SimpleObjectProperty<>(this, "typeEdition", null);
    private ObjectProperty<ValeurListe> formatEdition = new SimpleObjectProperty<>(this, "formatEdition", null);
    private ObjectProperty<ValeurListe> orientation = new SimpleObjectProperty<>(this, "orientation", null);
    private ObjectProperty<ValeurListe> sensLecture = new SimpleObjectProperty<>(this, "sensLecture", null);
    private ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);
    private ListProperty<UniversLite> univers = new SimpleListProperty<>(this, "univers", FXCollections.<UniversLite>observableList(new ArrayList<>()));

    public Serie() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        etat.set(valeurListeDao.getDefaultEtat());
        reliure.set(valeurListeDao.getDefaultReliure());
        typeEdition.set(valeurListeDao.getDefaultTypeEdition());
        formatEdition.set(valeurListeDao.getDefaultFormatEdition());
        orientation.set(valeurListeDao.getDefaultOrientation());
        sensLecture.set(valeurListeDao.getDefaultSensLecture());
        notation.set(valeurListeDao.getDefaultNotation());
    }

    public String getTitreSerie() {
        return BeanUtils.trimOrNull(titreSerie.get());
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie.set(BeanUtils.trimOrNull(titreSerie));
    }

    public StringProperty titreSerieProperty() {
        return titreSerie;
    }

    public Boolean getTerminee() {
        return terminee.get();
    }

    public void setTerminee(Boolean terminee) {
        this.terminee.set(terminee);
    }

    public ObjectProperty<Boolean> termineeProperty() {
        return terminee;
    }

    public List<GenreLite> getGenres() {
        return genres;
    }

    public void setGenres(List<GenreLite> genres) {
        this.genres.set(FXCollections.observableList(genres));
    }

    public boolean addGenre(GenreLite genre) {
        return genres.add(genre);
    }

    public boolean removeGenre(GenreLite genre) {
        return genres.remove(genre);
    }

    public ListProperty<GenreLite> genresProperty() {
        return genres;
    }

    public String getSujet() {
        return BeanUtils.trimOrNull(sujet.get());
    }

    public void setSujet(String sujet) {
        this.sujet.set(BeanUtils.trimOrNull(sujet));
    }

    public StringProperty sujetProperty() {
        return sujet;
    }

    public String getNotes() {
        return BeanUtils.trimOrNull(notes.get());
    }

    public void setNotes(String notes) {
        this.notes.set(BeanUtils.trimOrNull(notes));
    }

    public StringProperty notesProperty() {
        return notes;
    }

    public EditeurLite getEditeur() {
        return editeur.get();
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur.set(editeur);
    }

    public ObjectProperty<EditeurLite> editeurProperty() {
        return editeur;
    }

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }

    public CollectionLite getCollection() {
        return collection.get();
    }

    public void setCollection(CollectionLite collection) {
        this.collection.set(collection);
    }

    public ObjectProperty<CollectionLite> collectionProperty() {
        return collection;
    }

    public UUID getIdCollection() {
        return getEditeur() == null || getCollection() == null || !getCollection().getEditeur().equals(getEditeur()) ? null : getCollection().getId();
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

    public boolean isComplete() {
        return complete.get();
    }

    public void setComplete(boolean complete) {
        this.complete.set(complete);
    }

    public BooleanProperty completeProperty() {
        return complete;
    }

    public boolean isSuivreManquants() {
        return suivreManquants.get();
    }

    public void setSuivreManquants(boolean suivreManquants) {
        this.suivreManquants.set(suivreManquants);
    }

    public BooleanProperty suivreManquantsProperty() {
        return suivreManquants;
    }

    public boolean isSuivreSorties() {
        return suivreSorties.get();
    }

    public void setSuivreSorties(boolean suivreSorties) {
        this.suivreSorties.set(suivreSorties);
    }

    public BooleanProperty suivreSortiesProperty() {
        return suivreSorties;
    }

    public int getNbAlbums() {
        return nbAlbums.get();
    }

    public void setNbAlbums(int nbAlbums) {
        this.nbAlbums.set(nbAlbums);
    }

    public IntegerProperty nbAlbumsProperty() {
        return nbAlbums;
    }

    public List<AlbumLite> getAlbums() {
        return albums;
    }

    public void setAlbums(List<AlbumLite> albums) {
        this.albums.set(FXCollections.observableList(albums));
    }

    public ListProperty<AlbumLite> albumsProperty() {
        return albums;
    }

    public List<ParaBDLite> getParaBDs() {
        return paraBDs.get();
    }

    public void setParaBDs(List<ParaBDLite> paraBDs) {
        this.paraBDs.set(FXCollections.observableList(paraBDs));
    }

    private void buildListsAuteurs() {
        if (auteurs.size() != scenaristes.size() + dessinateurs.size() + coloristes.size()) {
            scenaristes.clear();
            dessinateurs.clear();
            coloristes.clear();
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
        this.auteurs.set(FXCollections.observableList(auteurs));
        scenaristes.set(FXCollections.observableList(new ArrayList<>()));
        dessinateurs.set(FXCollections.observableList(new ArrayList<>()));
        coloristes.set(FXCollections.observableList(new ArrayList<>()));
    }

    public ListProperty<AuteurSerieLite> auteursProperty() {
        return auteurs;
    }

    public ListProperty<AuteurSerieLite> scenaristesProperty() {
        return scenaristes;
    }

    public ListProperty<AuteurSerieLite> dessinateursProperty() {
        return dessinateurs;
    }

    public ListProperty<AuteurSerieLite> coloristesProperty() {
        return coloristes;
    }

    private boolean addAuteur(PersonneLite personne, List<AuteurSerieLite> listAuteurs, MetierAuteur metier) {
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

    private boolean removeAuteur(PersonneLite personne, List<AuteurSerieLite> listAuteurs) {
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
        return vo.get();
    }

    public void setVo(Boolean vo) {
        this.vo.set(vo);
    }

    public ObjectProperty<Boolean> voProperty() {
        return vo;
    }

    public Boolean getCouleur() {
        return couleur.get();
    }

    public void setCouleur(Boolean couleur) {
        this.couleur.set(couleur);
    }

    public ObjectProperty<Boolean> couleurProperty() {
        return couleur;
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

    public List<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers.set(FXCollections.observableList(univers));
    }

    public ListProperty<UniversLite> universProperty() {
        return univers;
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

    public ValeurListe getEtat() {
        return etat.get();
    }

    public void setEtat(ValeurListe etat) {
        this.etat.set(etat);
    }

    public ObjectProperty<ValeurListe> etatProperty() {
        return etat;
    }

    public ValeurListe getReliure() {
        return reliure.get();
    }

    public void setReliure(ValeurListe reliure) {
        this.reliure.set(reliure);
    }

    public ObjectProperty<ValeurListe> reliureProperty() {
        return reliure;
    }

    public ValeurListe getTypeEdition() {
        return typeEdition.get();
    }

    public void setTypeEdition(ValeurListe typeEdition) {
        this.typeEdition.set(typeEdition);
    }

    public ObjectProperty<ValeurListe> typeEditionProperty() {
        return typeEdition;
    }

    public ValeurListe getFormatEdition() {
        return formatEdition.get();
    }

    public void setFormatEdition(ValeurListe formatEdition) {
        this.formatEdition.set(formatEdition);
    }

    public ObjectProperty<ValeurListe> formatEditionProperty() {
        return formatEdition;
    }

    public ValeurListe getOrientation() {
        return orientation.get();
    }

    public void setOrientation(ValeurListe orientation) {
        this.orientation.set(orientation);
    }

    public ObjectProperty<ValeurListe> orientationProperty() {
        return orientation;
    }

    public ValeurListe getSensLecture() {
        return sensLecture.get();
    }

    public void setSensLecture(ValeurListe sensLecture) {
        this.sensLecture.set(sensLecture);
    }

    public ObjectProperty<ValeurListe> sensLectureProperty() {
        return sensLecture;
    }

}
