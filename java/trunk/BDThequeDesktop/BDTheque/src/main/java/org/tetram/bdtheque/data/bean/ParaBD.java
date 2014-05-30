package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.mappers.DefaultValeurListeMapper;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class ParaBD extends AbstractDBEntity {
    private Integer anneeEdition;
    private ValeurListe categorieParaBD = DefaultValeurListeMapper.getInstance().getTypeParaBD();
    private Integer anneeCote;
    private String titreParaBD;
    private List<AuteurParaBDLite> auteurs = new ArrayList<>();
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
    private Date dateAchat;
    private List<UniversLite> univers = new ArrayList<>();
    private List<UniversLite> universFull = new ArrayList<>();
    private List<PhotoLite> photos = new ArrayList<>();

    public Integer getAnneeEdition() {
        return anneeEdition;
    }

    public void setAnneeEdition(Integer anneeEdition) {
        this.anneeEdition = anneeEdition;
    }

    public Integer getAnneeCote() {
        return anneeCote;
    }

    public void setAnneeCote(Integer anneeCote) {
        this.anneeCote = anneeCote;
    }

    public String getTitreParaBD() {
        return titreParaBD;
    }

    public void setTitreParaBD(String titreParaBD) {
        this.titreParaBD = titreParaBD;
    }

    public List<AuteurParaBDLite> getAuteurs() {
        return auteurs;
    }

    public void setAuteurs(List<AuteurParaBDLite> auteurs) {
        this.auteurs = auteurs;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
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

    public List<PhotoLite> getPhotos() {
        return photos;
    }

    public void setPhotos(List<PhotoLite> photos) {
        this.photos = photos;
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
