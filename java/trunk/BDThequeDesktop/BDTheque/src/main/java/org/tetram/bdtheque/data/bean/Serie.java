package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.BaseSerie;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

@DaoScriptImpl.ScriptInfo(typeData = 7)
public class Serie extends BaseSerie implements ScriptEntity {

    public static Comparator<SerieLite> DEFAULT_COMPARATOR = new Comparator<SerieLite>() {
        @Override
        public int compare(SerieLite o1, SerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getTitreSerie(), o2.getTitreSerie());
            if (comparaison != 0) return comparaison;

            comparaison = EditeurLite.DEFAULT_COMPARATOR.compare(o1.getEditeur(), o2.getEditeur());
            if (comparaison != 0) return comparaison;

            comparaison = CollectionLite.DEFAULT_COMPARATOR.compare(o1.getCollection(), o2.getCollection());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };

    private final ObjectProperty<Boolean> terminee = new SimpleObjectProperty<>(this, "terminee", null);
    private final ListProperty<GenreLite> genres = new SimpleListProperty<>(this, "genres", FXCollections.<GenreLite>observableArrayList());
    private final StringProperty sujet = new AutoTrimStringProperty(this, "sujet", null);
    private final StringProperty notes = new AutoTrimStringProperty(this, "notes", null);
    private final ObjectProperty<EditeurLite> editeur = new SimpleObjectProperty<>(this, "editeur", null);
    private final ObjectProperty<CollectionLite> collection = new SimpleObjectProperty<>(this, "collection", null);
    private final BooleanProperty complete = new SimpleBooleanProperty(this, "complete", false);
    private final BooleanProperty suivreManquants = new SimpleBooleanProperty(this, "suivreManquants", false);
    private final BooleanProperty suivreSorties = new SimpleBooleanProperty(this, "suivreSorties", false);
    private final IntegerProperty nbAlbums = new SimpleIntegerProperty(this, "nbAlbums", 0);
    private final ListProperty<AlbumLite> albums = new SimpleListProperty<>(this, "albums", FXCollections.<AlbumLite>observableArrayList());
    private final ListProperty<ParaBDLite> paraBDs = new SimpleListProperty<>(this, "paraBDs", FXCollections.<ParaBDLite>observableArrayList());
    private final ListProperty<AuteurSerieLite> auteurs = new SimpleListProperty<>(this, "auteurs", FXCollections.<AuteurSerieLite>observableArrayList());
    private final ListProperty<AuteurSerieLite> scenaristes = new SimpleListProperty<>(this, "scenaristes", FXCollections.<AuteurSerieLite>observableArrayList());
    private final ListProperty<AuteurSerieLite> dessinateurs = new SimpleListProperty<>(this, "dessinateurs", FXCollections.<AuteurSerieLite>observableArrayList());
    private final ListProperty<AuteurSerieLite> coloristes = new SimpleListProperty<>(this, "coloristes", FXCollections.<AuteurSerieLite>observableArrayList());
    private final ObjectProperty<Boolean> vo = new SimpleObjectProperty<>(this, "vo", null);
    private final ObjectProperty<Boolean> couleur = new SimpleObjectProperty<>(this, "couleur", null);
    private final ObjectProperty<ValeurListe> etat = new SimpleObjectProperty<>(this, "etat", null);
    private final ObjectProperty<ValeurListe> reliure = new SimpleObjectProperty<>(this, "reliure", null);
    private final ObjectProperty<ValeurListe> typeEdition = new SimpleObjectProperty<>(this, "typeEdition", null);
    private final ObjectProperty<ValeurListe> formatEdition = new SimpleObjectProperty<>(this, "formatEdition", null);
    private final ObjectProperty<ValeurListe> orientation = new SimpleObjectProperty<>(this, "orientation", null);
    private final ObjectProperty<ValeurListe> sensLecture = new SimpleObjectProperty<>(this, "sensLecture", null);
    private final ListProperty<UniversLite> univers = new SimpleListProperty<>(this, "univers", FXCollections.<UniversLite>observableArrayList());
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    public Serie() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setEtat(valeurListeDao.getDefaultEtat());
        setReliure(valeurListeDao.getDefaultReliure());
        setTypeEdition(valeurListeDao.getDefaultTypeEdition());
        setFormatEdition(valeurListeDao.getDefaultFormatEdition());
        setOrientation(valeurListeDao.getDefaultOrientation());
        setSensLecture(valeurListeDao.getDefaultSensLecture());

        auteursProperty().addListener((observable, oldValue, newValue) -> buildListsAuteurs());
        auteursProperty().addListener((ListChangeListener<AuteurSerieLite>) c -> buildListsAuteurs());
    }

    public Boolean isTerminee() {
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
        return sujet.get();
    }

    public void setSujet(String sujet) {
        this.sujet.set(sujet);
    }

    public StringProperty sujetProperty() {
        return sujet;
    }

    public String getNotes() {
        return notes.get();
    }

    public void setNotes(String notes) {
        this.notes.set(notes);
    }

    public StringProperty notesProperty() {
        return notes;
    }

    public EditeurLite getEditeur() {
        return editeur.get();
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur.set(editeur);
        if (editeur == null) setCollection(null);
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

    public ListProperty<ParaBDLite> paraBDsProperty() {
        return paraBDs;
    }

    private void buildListsAuteurs() {
        int countAuteurs = scenaristes.size() + dessinateurs.size() + coloristes.size();

        if (auteurs.size() != countAuteurs) {
            scenaristes.set(FXCollections.observableList(new ArrayList<>()));
            dessinateurs.set(FXCollections.observableList(new ArrayList<>()));
            coloristes.set(FXCollections.observableList(new ArrayList<>()));
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

    private void addAuteur(PersonneLite personne, List<AuteurSerieLite> listAuteurs, MetierAuteur metier) {
        for (AuteurSerieLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) return;
        AuteurSerieLite auteur = new AuteurAlbumLite();
        auteur.setPersonne(personne);
        auteur.setMetier(metier);
        auteurs.add(auteur);
    }

    public void addScenariste(PersonneLite personne) {
        addAuteur(personne, getScenaristes(), MetierAuteur.SCENARISTE);
    }

    public void addDessinateur(PersonneLite personne) {
        addAuteur(personne, getDessinateurs(), MetierAuteur.DESSINATEUR);
    }

    public void addColoriste(PersonneLite personne) {
        addAuteur(personne, getColoristes(), MetierAuteur.COLORISTE);
    }

    private void removeAuteur(PersonneLite personne, List<AuteurSerieLite> listAuteurs) {
        for (AuteurSerieLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) {
                auteurs.remove(auteur);
                return;
            }
    }

    public void removeScenariste(PersonneLite personne) {
        removeAuteur(personne, getScenaristes());
    }

    public void removeDessinateur(PersonneLite personne) {
        removeAuteur(personne, getDessinateurs());
    }

    public void removeColoriste(PersonneLite personne) {
        removeAuteur(personne, getColoristes());
    }

    public List<AuteurSerieLite> getScenaristes() {
        return scenaristes;
    }

    public List<AuteurSerieLite> getDessinateurs() {
        return dessinateurs;
    }

    public List<AuteurSerieLite> getColoristes() {
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

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public String buildLabel() {
        String lb = getTitreSerie();
        lb = BeanUtils.formatTitre(lb);
        String s = "";
        if (getEditeur() != null)
            s = StringUtils.ajoutString("", BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ");
        if (getCollection() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getCollection().getNomCollection()), " - ");
        return StringUtils.ajoutString(lb, s, " ", "(", ")");
    }

}
