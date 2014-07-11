package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseEdition;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.time.LocalDate;
import java.time.Year;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class Edition extends BaseEdition<Editeur, Collection> {

    private static Edition defaultEdition = null;
    private final ObjectProperty<Integer> nombreDePages = new SimpleObjectProperty<>();
    private final BooleanProperty couleur = new SimpleBooleanProperty();
    private final BooleanProperty vo = new SimpleBooleanProperty();
    private final BooleanProperty dedicace = new SimpleBooleanProperty();
    private final BooleanProperty stock = new SimpleBooleanProperty();
    private final BooleanProperty prete = new SimpleBooleanProperty();
    private final BooleanProperty offert = new SimpleBooleanProperty();
    private final BooleanProperty gratuit = new SimpleBooleanProperty();
    private final ObjectProperty<UUID> idAlbum = new SimpleObjectProperty<>(this, "idAlbum", null);
    private final ObjectProperty<ValeurListe> etat= new SimpleObjectProperty<>(this, "etat", null);
    private final ObjectProperty<ValeurListe> reliure= new SimpleObjectProperty<>(this, "reliure", null);
    private final ObjectProperty<ValeurListe> typeEdition= new SimpleObjectProperty<>(this, "typeEdition", null);
    private final ObjectProperty<ValeurListe> formatEdition= new SimpleObjectProperty<>(this, "formatEdition", null);
    private final ObjectProperty<ValeurListe> orientation= new SimpleObjectProperty<>(this, "orientation", null);
    private final ObjectProperty<ValeurListe> sensLecture= new SimpleObjectProperty<>(this, "sensLecture", null);
    private final ObjectProperty<Year> anneeCote= new SimpleObjectProperty<>(this, "anneeCote", null);
    private final ObjectProperty<Double> prix= new SimpleObjectProperty<>(this, "prix", null);
    private final ObjectProperty<Double> prixCote= new SimpleObjectProperty<>(this, "prixCote", null);
    private final ObjectProperty<LocalDate> dateAchat= new SimpleObjectProperty<>(this, "dateAchat", null);
    private final StringProperty notes = new AutoTrimStringProperty(this, "notes", null);
    private final StringProperty numeroPerso = new AutoTrimStringProperty(this, "numeroPerso", null);
    private final ListProperty<CouvertureLite> couvertures = new SimpleListProperty<>(this, "couvertures", FXCollections.observableArrayList());

    public Edition() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setEtat(valeurListeDao.getDefaultEtat());
        setReliure(valeurListeDao.getDefaultReliure());
        setTypeEdition(valeurListeDao.getDefaultTypeEdition());
        setFormatEdition(valeurListeDao.getDefaultFormatEdition());
        setOrientation(valeurListeDao.getDefaultOrientation());
        setSensLecture(valeurListeDao.getDefaultSensLecture());
    }

    public static Edition getDefaultEdition() {
        if (defaultEdition == null) defaultEdition = new Edition();
        return defaultEdition;
    }

    public UUID getIdAlbum() {
        return idAlbum.get();
    }

    public ObjectProperty<UUID> idAlbumProperty() {
        return idAlbum;
    }

    public void setIdAlbum(UUID idAlbum) {
        this.idAlbum.set(idAlbum);
    }

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }


    public UUID getIdCollection() {
        return getEditeur() == null || getCollection() == null || !getCollection().getEditeur().equals(getEditeur()) ? null : getCollection().getId();
    }

    public Integer getNombreDePages() {
        return nombreDePages.get();
    }

    public void setNombreDePages(Integer nombreDePages) {
        this.nombreDePages.set(nombreDePages);
    }

    public ObjectProperty<Integer> nombreDePagesProperty() {
        return nombreDePages;
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

    public ValeurListe getEtat() {
        return etat.get();
    }

    public ObjectProperty<ValeurListe> etatProperty() {
        return etat;
    }

    public void setEtat(ValeurListe etat) {
        this.etat.set(etat);
    }

    public ValeurListe getReliure() {
        return reliure.get();
    }

    public ObjectProperty<ValeurListe> reliureProperty() {
        return reliure;
    }

    public void setReliure(ValeurListe reliure) {
        this.reliure.set(reliure);
    }

    public ValeurListe getTypeEdition() {
        return typeEdition.get();
    }

    public ObjectProperty<ValeurListe> typeEditionProperty() {
        return typeEdition;
    }

    public void setTypeEdition(ValeurListe typeEdition) {
        this.typeEdition.set(typeEdition);
    }

    public ValeurListe getFormatEdition() {
        return formatEdition.get();
    }

    public ObjectProperty<ValeurListe> formatEditionProperty() {
        return formatEdition;
    }

    public void setFormatEdition(ValeurListe formatEdition) {
        this.formatEdition.set(formatEdition);
    }

    public ValeurListe getOrientation() {
        return orientation.get();
    }

    public ObjectProperty<ValeurListe> orientationProperty() {
        return orientation;
    }

    public void setOrientation(ValeurListe orientation) {
        this.orientation.set(orientation);
    }

    public ValeurListe getSensLecture() {
        return sensLecture.get();
    }

    public ObjectProperty<ValeurListe> sensLectureProperty() {
        return sensLecture;
    }

    public void setSensLecture(ValeurListe sensLecture) {
        this.sensLecture.set(sensLecture);
    }

    public Year getAnneeCote() {
        return anneeCote.get();
    }

    public ObjectProperty<Year> anneeCoteProperty() {
        return anneeCote;
    }

    public void setAnneeCote(Year anneeCote) {
        this.anneeCote.set(anneeCote);
    }

    public Double getPrix() {
        return prix.get();
    }

    public ObjectProperty<Double> prixProperty() {
        return prix;
    }

    public void setPrix(Double prix) {
        this.prix.set(prix);
    }

    public Double getPrixCote() {
        return prixCote.get();
    }

    public ObjectProperty<Double> prixCoteProperty() {
        return prixCote;
    }

    public void setPrixCote(Double prixCote) {
        this.prixCote.set(prixCote);
    }

    public LocalDate getDateAchat() {
        return dateAchat.get();
    }

    public ObjectProperty<LocalDate> dateAchatProperty() {
        return dateAchat;
    }

    public void setDateAchat(LocalDate dateAchat) {
        this.dateAchat.set(dateAchat);
    }

    public String getNotes() {
        return notes.get();
    }

    public StringProperty notesProperty() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes.set(notes);
    }

    public String getNumeroPerso() {
        return numeroPerso.get();
    }

    public StringProperty numeroPersoProperty() {
        return numeroPerso;
    }

    public void setNumeroPerso(String numeroPerso) {
        this.numeroPerso.set(numeroPerso);
    }

    public List<CouvertureLite> getCouvertures() {
        return couvertures.get();
    }

    public ListProperty<CouvertureLite> couverturesProperty() {
        return couvertures;
    }

    public void setCouvertures(List<CouvertureLite> couvertures) {
        this.couvertures.set(FXCollections.observableList(couvertures));
    }

    public boolean addCouverture(CouvertureLite couverture) {
        return getCouvertures().add(couverture);
    }

    public boolean removeCouverture(CouvertureLite couverture) {
        return getCouvertures().remove(couverture);
    }

}
