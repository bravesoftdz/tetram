package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class Album extends BaseAlbum {

    private static Album defaultAlbum = null;
    private final ObjectProperty<Serie> serie = new SimpleObjectProperty<>(this, "serie", null);
    private final ListProperty<AuteurAlbumLite> auteurs = new SimpleListProperty<>(this, "auteurs", FXCollections.<AuteurAlbumLite>observableArrayList());
    private final ListProperty<AuteurAlbumLite> scenaristes = new SimpleListProperty<>(this, "scenaristes", FXCollections.<AuteurAlbumLite>observableArrayList());
    private final ListProperty<AuteurAlbumLite> dessinateurs = new SimpleListProperty<>(this, "dessinateurs", FXCollections.<AuteurAlbumLite>observableArrayList());
    private final ListProperty<AuteurAlbumLite> coloristes = new SimpleListProperty<>(this, "coloristes", FXCollections.<AuteurAlbumLite>observableArrayList());
    private final StringProperty sujet = new AutoTrimStringProperty(this, "sujet", null);
    private final StringProperty notes = new AutoTrimStringProperty(this, "notes", null);
    private final ListProperty<Edition> editions = new SimpleListProperty<>(this, "editions", FXCollections.<Edition>observableArrayList());
    private final ListProperty<UniversLite> univers = new SimpleListProperty<>(this, "univers", FXCollections.<UniversLite>observableArrayList());
    private final ListProperty<UniversLite> universFull = new SimpleListProperty<>(this, "universFull", FXCollections.<UniversLite>observableArrayList());

    public Album() {
        final ListChangeListener<UniversLite> universListChangeListener = change -> universFullProperty().set(FXCollections.observableList(BeanUtils.checkAndBuildListUniversFull(getUniversFull(), getUnivers(), getSerie())));
        serieProperty().addListener((observable, oldValue, newValue) -> {
            if (oldValue != null) oldValue.universProperty().removeListener(universListChangeListener);
            if (newValue != null) newValue.universProperty().addListener(universListChangeListener);
            universFullProperty().set(FXCollections.observableList(BeanUtils.checkAndBuildListUniversFull(getUniversFull(), getUnivers(), newValue)));
        });
        universProperty().addListener(universListChangeListener);

        auteursProperty().addListener((observable, oldValue, newValue) -> buildListsAuteurs());
        auteursProperty().addListener((ListChangeListener<AuteurAlbumLite>) c -> buildListsAuteurs());
    }

    public static Album getDefaultAlbum() {
        if (defaultAlbum == null) defaultAlbum = new Album();
        return defaultAlbum;
    }

    public Serie getSerie() {
        return serie.get();
    }

    public void setSerie(Serie serie) {
        this.serie.set(serie);
    }

    public ObjectProperty<Serie> serieProperty() {
        return serie;
    }

    public UUID getIdSerie() {
        return getSerie() == null ? null : getSerie().getId();
    }

    public List<AuteurAlbumLite> getAuteurs() {
        return auteurs.get();
    }

    public void setAuteurs(List<AuteurAlbumLite> auteurs) {
        this.auteurs.set(FXCollections.observableList(auteurs));
    }

    public ListProperty<AuteurAlbumLite> auteursProperty() {
        return auteurs;
    }

    private void buildListsAuteurs() {
        int countAuteurs = scenaristes.size() + dessinateurs.size() + coloristes.size();

        if (auteurs.size() != countAuteurs) {
            scenaristes.set(FXCollections.observableList(new ArrayList<>()));
            dessinateurs.set(FXCollections.observableList(new ArrayList<>()));
            coloristes.set(FXCollections.observableList(new ArrayList<>()));
            for (AuteurAlbumLite a : auteurs) {
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

    private void addAuteur(PersonneLite personne, List<AuteurAlbumLite> listAuteurs, MetierAuteur metier) {
        for (AuteurAlbumLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) return;
        AuteurAlbumLite auteur = new AuteurAlbumLite();
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

    private void removeAuteur(PersonneLite personne, List<AuteurAlbumLite> listAuteurs) {
        for (AuteurAlbumLite auteur : listAuteurs)
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

    public List<AuteurAlbumLite> getScenaristes() {
        return scenaristes.get();
    }

    public ListProperty<AuteurAlbumLite> scenaristesProperty() {
        return scenaristes;
    }

    public List<AuteurAlbumLite> getDessinateurs() {
        return dessinateurs.get();
    }

    public ListProperty<AuteurAlbumLite> dessinateursProperty() {
        return dessinateurs;
    }

    public List<AuteurAlbumLite> getColoristes() {
        return coloristes.get();
    }

    public ListProperty<AuteurAlbumLite> coloristesProperty() {
        return coloristes;
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

    public List<Edition> getEditions() {
        return editions.get();
    }

    public void setEditions(List<Edition> editions) {
        this.editions.set(FXCollections.observableList(editions));
    }

    public ListProperty<Edition> editionsProperty() {
        return editions;
    }

    public boolean addEdition(Edition edition) {
        return getEditions().add(edition);
    }

    public boolean removeEdition(Edition edition) {
        return getEditions().remove(edition);
    }

    public List<UniversLite> getUnivers() {
        return univers.get();
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers.set(FXCollections.observableList(univers));
    }

    public ListProperty<UniversLite> universProperty() {
        return univers;
    }

    public List<UniversLite> getUniversFull() {
        return universFull.get();
    }

    public ListProperty<UniversLite> universFullProperty() {
        return universFull;
    }

    public boolean addUnivers(UniversLite universLite) {
        if (!univers.contains(universLite) && !universFull.contains(universLite)) {
            universFull.add(universLite);
            return univers.add(universLite);
        }
        return false;
    }

    public boolean removeUnivers(UniversLite universLite) {
        if (univers.remove(universLite)) {
            universFull.remove(universLite);
            return true;
        } else
            return false;
    }

    @Override
    public String buildLabel(boolean simple, boolean avecSerie) {
        return BeanUtils.formatTitreAlbum(simple, avecSerie, getTitreAlbum(), getSerie() == null ? null : getSerie().getTitreSerie(), getTome(), getTomeDebut(), getTomeFin(), isIntegrale(), isHorsSerie());
    }

}
