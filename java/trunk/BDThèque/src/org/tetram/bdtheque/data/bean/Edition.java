package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.CouvertureLite;

import java.util.Currency;
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
    //property TypeEdition: ROption read FTypeEdition write FTypeEdition;
    //property Etat: ROption read FEtat write FEtat;
    //property Reliure: ROption read FReliure write FReliure;
    //property FormatEdition: ROption read FFormatEdition write FFormatEdition;
    //property Orientation: ROption read FOrientation write FOrientation;
    //property SensLecture: ROption read FSensLecture write FSensLecture;
    private Integer anneeEdition;
    private Integer nombreDePages;
    private Integer anneeCote;
    private Currency prix;
    private Currency prixCote;
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
    private List<CouvertureLite> couvertures;

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

    public Currency getPrix() {
        return prix;
    }

    public void setPrix(Currency prix) {
        this.prix = prix;
    }

    public Currency getPrixCote() {
        return prixCote;
    }

    public void setPrixCote(Currency prixCote) {
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
}
