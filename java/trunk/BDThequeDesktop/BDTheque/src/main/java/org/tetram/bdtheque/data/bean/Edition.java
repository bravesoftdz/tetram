package org.tetram.bdtheque.data.bean;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.ISBNUtils;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

import java.time.LocalDate;
import java.time.Year;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class Edition extends AbstractDBEntity {

    private static Edition defaultEdition = null;
    private UUID idAlbum;
    private Editeur editeur;
    private Collection collection;
    private ValeurListe etat;
    private ValeurListe reliure;
    private ValeurListe typeEdition;
    private ValeurListe formatEdition;
    private ValeurListe orientation;
    private ValeurListe sensLecture;
    private Year anneeEdition;
    private ObjectProperty<Integer> nombreDePages = new SimpleObjectProperty<>();
    private Year anneeCote;
    private Double prix;
    private Double prixCote;
    private BooleanProperty couleur = new SimpleBooleanProperty();
    private BooleanProperty vo = new SimpleBooleanProperty();
    private BooleanProperty dedicace = new SimpleBooleanProperty();
    private BooleanProperty stock = new SimpleBooleanProperty();
    private BooleanProperty prete = new SimpleBooleanProperty();
    private BooleanProperty offert = new SimpleBooleanProperty();
    private BooleanProperty gratuit = new SimpleBooleanProperty();
    private String isbn;
    private LocalDate dateAchat;
    private String notes;
    private String numeroPerso;
    private List<CouvertureLite> couvertures = new ArrayList<>();

    public Edition() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        etat = valeurListeDao.getDefaultEtat();
        reliure = valeurListeDao.getDefaultReliure();
        typeEdition = valeurListeDao.getDefaultTypeEdition();
        formatEdition = valeurListeDao.getDefaultFormatEdition();
        orientation = valeurListeDao.getDefaultOrientation();
        sensLecture = valeurListeDao.getDefaultSensLecture();
    }

    public static Edition getDefaultEdition() {
        if (defaultEdition == null) defaultEdition = new Edition();
        return defaultEdition;
    }

    @Override
    public String buildLabel() {
        String s = "";
        if (getEditeur() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ");
        if (getCollection() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getCollection().getNomCollection()), " ", "(", ")");
        s = StringUtils.ajoutString(s, TypeUtils.nonZero(getAnneeEdition()), " ", "[", "]");
        s = StringUtils.ajoutString(s, ISBNUtils.formatISBN(getIsbn()), " - ", I18nSupport.message("isbn") + " ");
        return s;
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

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }

    public Collection getCollection() {
        return collection;
    }

    public void setCollection(Collection collection) {
        this.collection = collection;
    }

    public UUID getIdCollection() {
        return getEditeur() == null || getCollection() == null || !getCollection().getEditeur().equals(getEditeur()) ? null : getCollection().getId();
    }

    public Year getAnneeEdition() {
        return anneeEdition;
    }

    public void setAnneeEdition(Year anneeEdition) {
        this.anneeEdition = anneeEdition;
    }

    public Integer getNombreDePages() {
        return nombreDePages.get();
    }

    public ObjectProperty<Integer> nombreDePagesProperty() {
        return nombreDePages;
    }

    public void setNombreDePages(Integer nombreDePages) {
        this.nombreDePages.set(nombreDePages);
    }

    public Year getAnneeCote() {
        return anneeCote;
    }

    public void setAnneeCote(Year anneeCote) {
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
        return couleur.get();
    }

    public void setCouleur(boolean couleur) {
        this.couleur.set(couleur);
    }

    public BooleanProperty couleurProperty() {
        return couleur;
    }

    public BooleanProperty voProperty() {
        return vo;
    }

    public BooleanProperty dedicaceProperty() {
        return dedicace;
    }

    public BooleanProperty stockProperty() {
        return stock;
    }

    public BooleanProperty preteProperty() {
        return prete;
    }

    public BooleanProperty offertProperty() {
        return offert;
    }

    public BooleanProperty gratuitProperty() {
        return gratuit;
    }

    public boolean isVo() {
        return vo.get();
    }

    public void setVo(boolean vo) {
        this.vo.set(vo);
    }

    public boolean isDedicace() {
        return dedicace.get();
    }

    public void setDedicace(boolean dedicace) {
        this.dedicace.set(dedicace);
    }

    public boolean isStock() {
        return stock.get();
    }

    public void setStock(boolean stock) {
        this.stock.set(stock);
    }

    public boolean isPrete() {
        return prete.get();
    }

    public void setPrete(boolean prete) {
        this.prete.set(prete);
    }

    public boolean isOffert() {
        return offert.get();
    }

    public void setOffert(boolean offert) {
        this.offert.set(offert);
    }

    public boolean isGratuit() {
        return gratuit.get();
    }

    public void setGratuit(boolean gratuit) {
        this.gratuit.set(gratuit);
    }

    public String getIsbn() {
        return BeanUtils.trimOrNull(isbn);
    }

    public void setIsbn(String isbn) {
        this.isbn = BeanUtils.trimOrNull(isbn);
    }

    public LocalDate getDateAchat() {
        return dateAchat;
    }

    public void setDateAchat(LocalDate dateAchat) {
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
