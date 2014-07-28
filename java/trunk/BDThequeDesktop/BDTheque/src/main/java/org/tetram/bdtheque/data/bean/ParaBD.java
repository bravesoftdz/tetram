package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.data.bean.interfaces.UniversAttachedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.time.LocalDate;
import java.time.Year;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

public class ParaBD extends BaseParaBD implements UniversAttachedEntity {

    private final ObjectProperty<Year> anneeEdition = new SimpleObjectProperty<>(this, "anneeEdition", null);
    private final ObjectProperty<ValeurListe> categorieParaBD = new SimpleObjectProperty<>(this, "categorieParaBD", null);
    private final ObjectProperty<Year> anneeCote = new SimpleObjectProperty<>(this, "anneeCote", null);
    private final ListProperty<AuteurParaBDLite> auteurs = new SimpleListProperty<>(this, "auteurs", FXCollections.observableArrayList());
    private final StringProperty description = new AutoTrimStringProperty(this, "description", null);
    private final StringProperty notes = new AutoTrimStringProperty(this, "notes", null);
    private final ObjectProperty<Serie> serie = new SimpleObjectProperty<>(this, "serie", null);
    private final ObjectProperty<Double> prix = new SimpleObjectProperty<>(this, "prix", null);
    private final ObjectProperty<Double> prixCote = new SimpleObjectProperty<>(this, "prixCote", null);
    private final BooleanProperty dedicace = new SimpleBooleanProperty(this, "dedicace", false);
    private final BooleanProperty numerote = new SimpleBooleanProperty(this, "numerote", false);
    private final BooleanProperty stock = new SimpleBooleanProperty(this, "stock", false);
    private final BooleanProperty offert = new SimpleBooleanProperty(this, "offert", false);
    private final BooleanProperty gratuit = new SimpleBooleanProperty(this, "gratuit", false);
    private final ObjectProperty<LocalDate> dateAchat = new SimpleObjectProperty<>(this, "dateAchat", null);
    private final ListProperty<UniversLite> univers = new SimpleListProperty<>(this, "univers", FXCollections.<UniversLite>observableArrayList());
    private final ListProperty<UniversLite> universFull = new SimpleListProperty<>(this, "universFull", FXCollections.<UniversLite>observableArrayList());
    private final ListProperty<PhotoLite> photos = new SimpleListProperty<>(this, "photos", FXCollections.observableArrayList());

    public ParaBD() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setCategorieParaBD(valeurListeDao.getDefaultTypeParaBD());

        initUniversProperties();
    }

    public Year getAnneeEdition() {
        return anneeEdition.get();
    }

    public void setAnneeEdition(Year anneeEdition) {
        this.anneeEdition.set(anneeEdition);
    }

    public ObjectProperty<Year> anneeEditionProperty() {
        return anneeEdition;
    }

    public ValeurListe getCategorieParaBD() {
        return categorieParaBD.get();
    }

    public void setCategorieParaBD(ValeurListe categorieParaBD) {
        this.categorieParaBD.set(categorieParaBD);
    }

    public ObjectProperty<ValeurListe> categorieParaBDProperty() {
        return categorieParaBD;
    }

    public Year getAnneeCote() {
        return anneeCote.get();
    }

    public void setAnneeCote(Year anneeCote) {
        this.anneeCote.set(anneeCote);
    }

    public ObjectProperty<Year> anneeCoteProperty() {
        return anneeCote;
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

    public Double getPrix() {
        return prix.get();
    }

    public void setPrix(Double prix) {
        this.prix.set(prix);
    }

    public ObjectProperty<Double> prixProperty() {
        return prix;
    }

    public Double getPrixCote() {
        return prixCote.get();
    }

    public void setPrixCote(Double prixCote) {
        this.prixCote.set(prixCote);
    }

    public ObjectProperty<Double> prixCoteProperty() {
        return prixCote;
    }

    public LocalDate getDateAchat() {
        return dateAchat.get();
    }

    public void setDateAchat(LocalDate dateAchat) {
        this.dateAchat.set(dateAchat);
    }

    public ObjectProperty<LocalDate> dateAchatProperty() {
        return dateAchat;
    }

    public List<AuteurParaBDLite> getAuteurs() {
        return auteurs.get();
    }

    public void setAuteurs(List<AuteurParaBDLite> auteurs) {
        this.auteurs.set(FXCollections.observableList(auteurs));
    }

    public ListProperty<AuteurParaBDLite> auteursProperty() {
        return auteurs;
    }

    public void addAuteur(PersonneLite personne) {
        for (AuteurParaBDLite auteur : auteurs)
            if (auteur.getPersonne().equals(personne)) return;
        AuteurParaBDLite auteur = new AuteurParaBDLite();
        auteur.setPersonne(personne);
        auteurs.add(auteur);
    }

    public void removeAuteur(PersonneLite personne) {
        auteurs.removeIf(a -> a.getPersonne().equals(personne));
    }

    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    public StringProperty descriptionProperty() {
        return description;
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

    public boolean isDedicace() {
        return dedicace.get();
    }

    public void setDedicace(boolean dedicace) {
        this.dedicace.set(dedicace);
    }

    public BooleanProperty dedicaceProperty() {
        return dedicace;
    }

    public boolean isNumerote() {
        return numerote.get();
    }

    public void setNumerote(boolean numerote) {
        this.numerote.set(numerote);
    }

    public BooleanProperty numeroteProperty() {
        return numerote;
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

    public boolean isOffert() {
        return offert.get();
    }

    public void setOffert(boolean offert) {
        this.offert.set(offert);
    }

    public BooleanProperty offertProperty() {
        return offert;
    }

    public boolean isGratuit() {
        return gratuit.get();
    }

    public void setGratuit(boolean gratuit) {
        this.gratuit.set(gratuit);
    }

    public BooleanProperty gratuitProperty() {
        return gratuit;
    }

    @Override
    public ListProperty<UniversLite> universProperty() {
        return univers;
    }

    @Override
    public ListProperty<UniversLite> universFullProperty() {
        return universFull;
    }

    public List<PhotoLite> getPhotos() {
        return photos;
    }

    public void setPhotos(List<PhotoLite> photos) {
        this.photos.set(FXCollections.observableList(photos));
    }

    public ListProperty<PhotoLite> photosProperty() {
        return photos;
    }

    public boolean addPhoto(PhotoLite photo) {
        return getPhotos().add(photo);
    }

    public boolean removePhoto(PhotoLite photo) {
        return getPhotos().remove(photo);
    }

    public UUID getIdSerie() {
        return getSerie() == null ? null : getSerie().getId();
    }

    @Override
    protected String buildLabel(boolean simple, boolean avecSerie) {
        String lb = super.buildLabel(simple, avecSerie);
        String s = "";
        if (avecSerie && getSerie() != null)
            if ("".equals(lb))
                lb = BeanUtils.formatTitre(getSerie().getTitreSerie());
            else
                s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getSerie().getTitreSerie()), " - ");
        if (getCategorieParaBD() != null)
            s = StringUtils.ajoutString(s, getCategorieParaBD().getTexte(), " - ");
        if ("".equals(lb))
            return s;
        else
            return StringUtils.ajoutString(lb, s, " ", "(", ")");

    }

}
