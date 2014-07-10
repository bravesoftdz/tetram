package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

import java.time.LocalDate;
import java.time.Year;
import java.util.*;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class ParaBD extends AbstractDBEntity {

    private Year anneeEdition;
    private ValeurListe categorieParaBD;
    private Year anneeCote;
    private String titreParaBD;
    private Set<AuteurParaBDLite> auteurs = new HashSet<>();
    private String description;
    private String notes;
    private Serie serie;
    private Double prix;
    private Double prixCote;
    private boolean dedicace;
    private boolean numerote;
    private boolean stock;
    private boolean offert;
    private boolean gratuit;
    private LocalDate dateAchat;
    private List<UniversLite> univers = new ArrayList<>();
    private List<UniversLite> universFull = new ArrayList<>();
    private List<PhotoLite> photos = new ArrayList<>();

    public ParaBD() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        categorieParaBD = valeurListeDao.getDefaultTypeParaBD();
    }

    public Year getAnneeEdition() {
        return anneeEdition;
    }

    public void setAnneeEdition(Year anneeEdition) {
        this.anneeEdition = anneeEdition;
    }

    public Year getAnneeCote() {
        return anneeCote;
    }

    public void setAnneeCote(Year anneeCote) {
        this.anneeCote = anneeCote;
    }

    public String getTitreParaBD() {
        return BeanUtils.trimOrNull(titreParaBD);
    }

    public void setTitreParaBD(String titreParaBD) {
        this.titreParaBD = BeanUtils.trimOrNull(titreParaBD);
    }

    public Set<AuteurParaBDLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(Set<AuteurParaBDLite> auteurs) {
        this.auteurs = auteurs;
    }

    public void addAuteur(PersonneLite personne) {
        for (AuteurParaBDLite auteur : auteurs)
            if (auteur.getPersonne() == personne) return;
        AuteurParaBDLite auteur = new AuteurParaBDLite();
        auteur.setPersonne(personne);
        auteurs.add(auteur);
    }

    public void removeAuteur(PersonneLite personne) {
        for (AuteurParaBDLite auteur : auteurs)
            if (auteur.getPersonne() == personne) {
                auteurs.remove(auteur);
                return;
            }
    }

    public String getDescription() {
        return BeanUtils.trimOrNull(description);
    }

    public void setDescription(String description) {
        this.description = BeanUtils.trimOrNull(description);
    }

    public String getNotes() {
        return BeanUtils.trimOrNull(notes);
    }

    public void setNotes(String notes) {
        this.notes = BeanUtils.trimOrNull(notes);
    }

    public Serie getSerie() {
        return serie;
    }

    public void setSerie(Serie serie) {
        this.serie = serie;
    }

    public Double getPrix() {
        return prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }

    public Double getPrixCote() {
        return prixCote;
    }

    public void setPrixCote(Double prixCote) {
        this.prixCote = prixCote;
    }

    public boolean isDedicace() {
        return dedicace;
    }

    public void setDedicace(boolean dedicace) {
        this.dedicace = dedicace;
    }

    public boolean isNumerote() {
        return numerote;
    }

    public void setNumerote(boolean numerote) {
        this.numerote = numerote;
    }

    public boolean isStock() {
        return stock;
    }

    public void setStock(boolean stock) {
        this.stock = stock;
    }

    public boolean isOffert() {
        return offert;
    }

    public void setOffert(boolean offert) {
        this.offert = offert;
    }

    public boolean isGratuit() {
        return gratuit;
    }

    public void setGratuit(boolean gratuit) {
        this.gratuit = gratuit;
    }

    public LocalDate getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(LocalDate dateAchat) {
        this.dateAchat = dateAchat;
    }

    public List<UniversLite> getUnivers() {
        return univers;
    }

    public void setUnivers(List<UniversLite> univers) {
        this.univers = univers;
    }

    public List<UniversLite> getUniversFull() {
        universFull = BeanUtils.checkAndBuildListUniversFull(universFull, univers, serie);
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

    public List<PhotoLite> getPhotos() {
        return photos;
    }

    public void setPhotos(List<PhotoLite> photos) {
        this.photos = photos;
    }

    public boolean addPhoto(PhotoLite photo) {
        return getPhotos().add(photo);
    }

    public boolean removePhoto(PhotoLite photo) {
        return getPhotos().remove(photo);
    }

    public ValeurListe getCategorieParaBD() {
        return categorieParaBD;
    }

    public void setCategorieParaBD(ValeurListe categorieParaBD) {
        this.categorieParaBD = categorieParaBD;
    }

    public UUID getIdSerie() {
        return serie.getId();
    }

}
