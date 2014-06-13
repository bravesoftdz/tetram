package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Edition extends AbstractDBEntity {
    private UUID idAlbum;
    private Editeur editeur;
    private Collection collection;
    private ValeurListe etat;
    private ValeurListe reliure;
    private ValeurListe typeEdition;
    private ValeurListe formatEdition;
    private ValeurListe orientation;
    private ValeurListe sensLecture;
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

    public Edition() {
        ValeurListeDao valeurListeDao = Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class);
        etat = valeurListeDao.getDefaultEtat();
        reliure = valeurListeDao.getDefaultReliure();
        typeEdition = valeurListeDao.getDefaultTypeEdition();
        formatEdition = valeurListeDao.getDefaultFormatEdition();
        orientation = valeurListeDao.getDefaultOrientation();
        sensLecture = valeurListeDao.getDefaultSensLecture();
    }

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
        return BeanUtils.trimOrNull(isbn);
    }

    public void setIsbn(String isbn) {
        this.isbn = BeanUtils.trimOrNull(isbn);
    }

    public Date getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(Date dateAchat) {
        this.dateAchat = dateAchat;
    }

    public String getNotes() {
        return BeanUtils.trimOrNull(notes);
    }

    public void setNotes(String notes) {
        this.notes = BeanUtils.trimOrNull(notes);
    }

    public String getNumeroPerso() {
        return BeanUtils.trimOrNull(numeroPerso);
    }

    public void setNumeroPerso(String numeroPerso) {
        this.numeroPerso = BeanUtils.trimOrNull(numeroPerso);
    }

    public List<CouvertureLite> getCouvertures() {
        return couvertures;
    }

    public void setCouvertures(List<CouvertureLite> couvertures) {
        this.couvertures = couvertures;
    }

    public boolean addCouverture(CouvertureLite couverture) {
        return getCouvertures().add(couverture);
    }

    public boolean removeCouverture(CouvertureLite couverture) {
        return getCouvertures().remove(couverture);
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
