package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.CouvertureLite;
import org.tetram.bdtheque.data.dao.DefaultValeurListeDao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Edition extends DBEntity {
    private UUID idAlbum;
    private Editeur editeur;
    private Collection collection;
    private ValeurListe etat = DefaultValeurListeDao.getInstance().getEtat();
    private ValeurListe reliure = DefaultValeurListeDao.getInstance().getReliure();
    private ValeurListe typeEdition = DefaultValeurListeDao.getInstance().getTypeEdition();
    private ValeurListe formatEdition = DefaultValeurListeDao.getInstance().getFormatEdition();
    private ValeurListe orientation = DefaultValeurListeDao.getInstance().getOrientation();
    private ValeurListe sensLecture = DefaultValeurListeDao.getInstance().getSensLecture();
    private Integer anneeEdition;
    private Integer nombreDePages;
    private Integer anneeCote;
    private Double prix;
    private Double prixCote;
    private boolean couleur;
    private boolean vo;
    private boolean dedicace;
    private boolean stock;
    private boolean prete;
    private boolean offert;
    private boolean gratuit;
    private String isbn;
    private Date dateAchat;
    private String notes;
    private String numeroPerso;
    private List<CouvertureLite> couvertures = new ArrayList<>();

    public UUID getIdAlbum() {
        return idAlbum;
    }

    public void setIdAlbum(UUID idAlbum) {
        this.idAlbum = idAlbum;
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

    public Integer getAnneeEdition() {
        return anneeEdition;
    }

    public void setAnneeEdition(Integer anneeEdition) {
        this.anneeEdition = anneeEdition;
    }

    public Integer getNombreDePages() {
        return nombreDePages;
    }

    public void setNombreDePages(Integer nombreDePages) {
        this.nombreDePages = nombreDePages;
    }

    public Integer getAnneeCote() {
        return anneeCote;
    }

    public void setAnneeCote(Integer anneeCote) {
        this.anneeCote = anneeCote;
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

    public boolean isCouleur() {
        return couleur;
    }

    public void setCouleur(boolean couleur) {
        this.couleur = couleur;
    }

    public boolean isVo() {
        return vo;
    }

    public void setVo(boolean vo) {
        this.vo = vo;
    }

    public boolean isDedicace() {
        return dedicace;
    }

    public void setDedicace(boolean dedicace) {
        this.dedicace = dedicace;
    }

    public boolean isStock() {
        return stock;
    }

    public void setStock(boolean stock) {
        this.stock = stock;
    }

    public boolean isPrete() {
        return prete;
    }

    public void setPrete(boolean prete) {
        this.prete = prete;
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

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat = dateAchat;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getNumeroPerso() {
        return numeroPerso;
    }

    public void setNumeroPerso(String numeroPerso) {
        this.numeroPerso = numeroPerso;
    }

    public List<CouvertureLite> getCouvertures() {
        return couvertures;
    }

    public void setCouvertures(List<CouvertureLite> couvertures) {
        this.couvertures = couvertures;
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
