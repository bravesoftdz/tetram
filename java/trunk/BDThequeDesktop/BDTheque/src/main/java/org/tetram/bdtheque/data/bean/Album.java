package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableSet;
import javafx.collections.SetChangeListener;
import org.tetram.bdtheque.AutoTrimStringProperty;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.utils.TypeUtils;

import java.time.Month;
import java.time.Year;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class Album extends AbstractDBEntity implements EvaluatedEntity {

    public static Comparator<Album> DEFAULT_COMPARATOR = new Comparator<Album>() {
        @Override
        public int compare(Album o1, Album o2) {
            if (o1 == o2) return 0;

            int comparaison;

            // horsSerie nulls first
            comparaison = BeanUtils.compare(o1.isHorsSerie(), o2.isHorsSerie());
            if (comparaison != 0) return comparaison;

            // integrale nulls first
            comparaison = BeanUtils.compare(o1.isIntegrale(), o2.isIntegrale());
            if (comparaison != 0) return comparaison;

            // tome nulls first
            comparaison = BeanUtils.compare(o1.getTome(), o2.getTome());
            if (comparaison != 0) return comparaison;

            // anneeParution nulls first
            comparaison = BeanUtils.compare(o1.getAnneeParution(), o2.getAnneeParution());
            if (comparaison != 0) return comparaison;

            // moisParution nulls first
            comparaison = BeanUtils.compare(o1.getMoisParution(), o2.getMoisParution());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private static Album defaultAlbum = null;
    private BooleanProperty complet = new SimpleBooleanProperty(this, "complet", false);
    private StringProperty titreAlbum = new AutoTrimStringProperty(this, "titreAlbum", null);
    private ObjectProperty<Serie> serie = new SimpleObjectProperty<>(this, "serie", null);
    private ObjectProperty<Month> moisParution = new SimpleObjectProperty<>(this, "moisParution", null);
    private ObjectProperty<Year> anneeParution = new SimpleObjectProperty<>(this, "anneeParution", null);
    private ObjectProperty<Integer> tome = new SimpleObjectProperty<>(this, "tome", null);
    private ObjectProperty<Integer> tomeDebut = new SimpleObjectProperty<>(this, "tomeDebut", null);
    private ObjectProperty<Integer> tomeFin = new SimpleObjectProperty<>(this, "tomeFin", null);
    private BooleanProperty horsSerie = new SimpleBooleanProperty(this, "horsSerie", false);
    private BooleanProperty integrale = new SimpleBooleanProperty(this, "integrale", false);
    private Set<AuteurAlbumLite> auteurs = new HashSet<>();
    private Set<AuteurAlbumLite> scenaristes = null;
    private Set<AuteurAlbumLite> dessinateurs = null;
    private Set<AuteurAlbumLite> coloristes = null;
    private StringProperty sujet = new AutoTrimStringProperty(this, "sujet", null);
    private StringProperty notes = new AutoTrimStringProperty(this, "notes", null);
    @SuppressWarnings("Convert2Diamond")
    private SetProperty<Edition> editions = new SimpleSetProperty<>(this, "editions", FXCollections.observableSet(new HashSet<Edition>()));
    private ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);
    private SetProperty<UniversLite> univers = new SimpleSetProperty<>(this, "univers", FXCollections.observableSet(new HashSet<>()));
    private SetProperty<UniversLite> universFull = new SimpleSetProperty<>(this, "universFull", FXCollections.observableSet(new HashSet<>()));

    public Album() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        notation.set(valeurListeDao.getDefaultNotation());


        final SetChangeListener<UniversLite> universSetChangeListener = new SetChangeListener<UniversLite>() {
            @Override
            public void onChanged(Change<? extends UniversLite> change) {
                universFull.set(FXCollections.observableSet(BeanUtils.checkAndBuildListUniversFull(getUniversFull(), getUnivers(), getSerie())));
            }
        };
        serie.addListener(new ChangeListener<Serie>() {
            @Override
            public void changed(ObservableValue<? extends Serie> observable, Serie oldValue, Serie newValue) {
                if (oldValue != null) oldValue.universProperty().removeListener(universSetChangeListener);
                if (newValue != null) newValue.universProperty().addListener(universSetChangeListener);
            }
        });
        univers.addListener(universSetChangeListener);
    }

    public static Album getDefaultAlbum() {
        if (defaultAlbum == null) defaultAlbum = new Album();
        return defaultAlbum;
    }

    public boolean isComplet() {
        return complet.get();
    }

    public void setComplet(boolean complet) {
        this.complet.set(complet);
    }

    public BooleanProperty completProperty() {
        return complet;
    }

    public String getTitreAlbum() {
        return titreAlbum.get();
    }

    public void setTitreAlbum(String titreAlbum) {
        this.titreAlbum.set(titreAlbum);
    }

    public StringProperty titreAlbumProperty() {
        return titreAlbum;
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

    public Month getMoisParution() {
        return TypeUtils.isNullOrZero(getAnneeParution()) ? null : moisParution.get();
    }

    public void setMoisParution(Month moisParution) {
        this.moisParution.set(moisParution);
    }

    public ObjectProperty<Month> moisParutionProperty() {
        return moisParution;
    }

    public Year getAnneeParution() {
        return anneeParution.get();
    }

    public void setAnneeParution(Year anneeParution) {
        this.anneeParution.set(anneeParution);
    }

    public ObjectProperty<Year> anneeParutionProperty() {
        return anneeParution;
    }

    public Integer getTome() {
        return tome.get();
    }

    public void setTome(Integer tome) {
        this.tome.set(tome);
    }

    public ObjectProperty<Integer> tomeProperty() {
        return tome;
    }

    public Integer getTomeDebut() {
        return tomeDebut.get();
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut.set(tomeDebut);
    }

    public ObjectProperty<Integer> tomeDebutProperty() {
        return tomeDebut;
    }

    public Integer getTomeFin() {
        return tomeFin.get();
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin.set(tomeFin);
    }

    public ObjectProperty<Integer> tomeFinProperty() {
        return tomeFin;
    }

    public boolean isHorsSerie() {
        return horsSerie.get();
    }

    public void setHorsSerie(boolean horsSerie) {
        this.horsSerie.set(horsSerie);
    }

    public BooleanProperty horsSerieProperty() {
        return horsSerie;
    }

    public boolean isIntegrale() {
        return integrale.get();
    }

    public void setIntegrale(boolean integrale) {
        this.integrale.set(integrale);
    }

    public BooleanProperty integraleProperty() {
        return integrale;
    }

    public Set<AuteurAlbumLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(Set<AuteurAlbumLite> auteurs) {
        this.auteurs = auteurs;
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

    public Set<AuteurAlbumLite> getScenaristes() {
        buildListsAuteurs();
        return scenaristes;
    }

    private void addAuteur(PersonneLite personne, Set<AuteurAlbumLite> listAuteurs, MetierAuteur metier) {
        for (AuteurAlbumLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) return;
        AuteurAlbumLite auteur = new AuteurAlbumLite();
        auteur.setPersonne(personne);
        auteur.setMetier(metier);
        listAuteurs.add(auteur);
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

    private void removeAuteur(PersonneLite personne, Set<AuteurAlbumLite> listAuteurs) {
        for (AuteurAlbumLite auteur : listAuteurs)
            if (auteur.getPersonne() == personne) {
                listAuteurs.remove(auteur);
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

    public Set<AuteurAlbumLite> getDessinateurs() {
        buildListsAuteurs();
        return dessinateurs;
    }

    public Set<AuteurAlbumLite> getColoristes() {
        buildListsAuteurs();
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

    public Set<Edition> getEditions() {
        return editions.get();
    }

    public void setEditions(Set<Edition> editions) {
        this.editions.set(FXCollections.observableSet(editions));
    }

    public SetProperty<Edition> editionsProperty() {
        return editions;
    }

    public boolean addEdition(Edition edition) {
        return getEditions().add(edition);
    }

    public boolean removeEdition(Edition edition) {
        return getEditions().remove(edition);
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

    public Set<UniversLite> getUnivers() {
        return univers.get();
    }

    public void setUnivers(Set<UniversLite> univers) {
        this.univers.set(FXCollections.observableSet(univers));
    }

    public SetProperty<UniversLite> universProperty() {
        return univers;
    }

    public ObservableSet<UniversLite> getUniversFull() {
        return universFull.get();
    }

    public SetProperty<UniversLite> universFullProperty() {
        return universFull;
    }

    @SuppressWarnings("SimplifiableIfStatement")
    public boolean addUnivers(UniversLite universLite) {
        if (!getUnivers().contains(universLite) && !getUniversFull().contains(universLite)) {
            universFull.add(universLite);
            return univers.add(universLite);
        }
        return false;
    }

    public boolean removeUnivers(UniversLite universLite) {
        if (getUnivers().remove(universLite)) {
            getUniversFull().remove(universLite);
            return true;
        } else
            return false;
    }

}
