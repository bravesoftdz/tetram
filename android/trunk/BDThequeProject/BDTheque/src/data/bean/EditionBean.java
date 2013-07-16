package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.EditionFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.Date;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITIONS_TABLENAME, primaryKey = DDLConstants.EDITIONS_ID, factoryClass = EditionFactory.class)
public class EditionBean extends CommonBean {

    private String isbn;
    private EditeurBean editeur;
    private CollectionLiteBean collection;
    private boolean stock;
    private boolean couleur;
    private boolean dedicace;
    private boolean offert;
    private Integer annee;
    private Date dateAquisition;
    private String notes;
    private Integer pages;
    private String numeroPerso;
    private boolean gratuit;
    private Double prix;
    private Double prixCote;
    private Integer anneeCote;
    private ListeBean typeEdition;
    private ListeBean reliure;
    private ListeBean etat;
    private ListeBean orientation;
    private ListeBean formatEdition;
    private ListeBean sensLecture;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<EditionBean> CREATOR = new Creator<EditionBean>() {
        @Override
        public EditionBean createFromParcel(Parcel source) {
            return new EditionBean(source);
        }

        @Override
        public EditionBean[] newArray(int size) {
            return new EditionBean[size];
        }
    };

    public EditionBean(Parcel in) {
        super(in);
    }

    public EditionBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.isbn);
        dest.writeParcelable(this.editeur, flags);
        dest.writeParcelable(this.collection, flags);
        dest.writeValue(this.annee);
        dest.writeValue(this.prix);
        dest.writeValue(this.stock);
        dest.writeValue(this.couleur);
        dest.writeValue(this.dedicace);
        dest.writeValue(this.offert);
        dest.writeValue(this.dateAquisition);
        dest.writeString(this.notes);
        dest.writeValue(this.pages);
        dest.writeString(this.numeroPerso);
        dest.writeValue(this.gratuit);
        dest.writeValue(this.anneeCote);
        dest.writeValue(this.prixCote);
        dest.writeParcelable(this.typeEdition, flags);
        dest.writeParcelable(this.reliure, flags);
        dest.writeParcelable(this.etat, flags);
        dest.writeParcelable(this.orientation, flags);
        dest.writeParcelable(this.formatEdition, flags);
        dest.writeParcelable(this.sensLecture, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.isbn = in.readString();
        this.editeur = in.readParcelable(EditeurBean.class.getClassLoader());
        this.collection = in.readParcelable(CollectionLiteBean.class.getClassLoader());
        this.annee = (Integer) in.readValue(Integer.class.getClassLoader());
        this.prix = (Double) in.readValue(Double.class.getClassLoader());
        this.stock = (boolean) in.readValue(Boolean.class.getClassLoader());
        this.couleur = (boolean) in.readValue(Boolean.class.getClassLoader());
        this.dedicace = (boolean) in.readValue(Boolean.class.getClassLoader());
        this.offert = (boolean) in.readValue(Boolean.class.getClassLoader());
        this.dateAquisition = (Date) in.readValue(Date.class.getClassLoader());
        this.notes = in.readString();
        this.pages = (Integer) in.readValue(Integer.class.getClassLoader());
        this.numeroPerso = in.readString();
        this.gratuit = (boolean) in.readValue(Boolean.class.getClassLoader());
        this.anneeCote = (Integer) in.readValue(Integer.class.getClassLoader());
        this.prixCote = (Double) in.readValue(Double.class.getClassLoader());
        this.typeEdition = in.readParcelable(ListeBean.class.getClassLoader());
        this.reliure = in.readParcelable(ListeBean.class.getClassLoader());
        this.etat = in.readParcelable(ListeBean.class.getClassLoader());
        this.orientation = in.readParcelable(ListeBean.class.getClassLoader());
        this.formatEdition = in.readParcelable(ListeBean.class.getClassLoader());
        this.sensLecture = in.readParcelable(ListeBean.class.getClassLoader());
    }

    public String getISBN() {
        return this.isbn;
    }

    public void setISBN(String isbn) {
        this.isbn = isbn;
    }

    public EditeurBean getEditeur() {
        return this.editeur;
    }

    public void setEditeur(EditeurBean editeur) {
        this.editeur = editeur;
    }

    public CollectionLiteBean getCollection() {
        return this.collection;
    }

    public void setCollection(CollectionLiteBean collection) {
        this.collection = collection;
    }

    public boolean isStock() {
        return this.stock;
    }

    public void setStock(boolean stock) {
        this.stock = stock;
    }

    public boolean isCouleur() {
        return this.couleur;
    }

    public void setCouleur(boolean couleur) {
        this.couleur = couleur;
    }

    public boolean isDedicace() {
        return this.dedicace;
    }

    public void setDedicace(boolean dedicace) {
        this.dedicace = dedicace;
    }

    public boolean isOffert() {
        return this.offert;
    }

    public void setOffert(boolean offert) {
        this.offert = offert;
    }

    public Integer getAnnee() {
        return this.annee;
    }

    public void setAnnee(Integer annee) {
        this.annee = annee;
    }

    public Date getDateAquisition() {
        return this.dateAquisition;
    }

    public void setDateAquisition(Date dateAquisition) {
        this.dateAquisition = dateAquisition;
    }

    public String getNotes() {
        return this.notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Integer getPages() {
        return this.pages;
    }

    public void setPages(Integer pages) {
        this.pages = pages;
    }

    public String getNumeroPerso() {
        return this.numeroPerso;
    }

    public void setNumeroPerso(String numeroPerso) {
        this.numeroPerso = numeroPerso;
    }

    public boolean isGratuit() {
        return this.gratuit;
    }

    public void setGratuit(boolean gratuit) {
        this.gratuit = gratuit;
    }

    public Double getPrix() {
        return this.prix;
    }

    public void setPrix(Double prix) {
        this.prix = prix;
    }

    public Double getPrixCote() {
        return this.prixCote;
    }

    public void setPrixCote(Double prixCote) {
        this.prixCote = prixCote;
    }

    public Integer getAnneeCote() {
        return this.anneeCote;
    }

    public void setAnneeCote(Integer anneeCote) {
        this.anneeCote = anneeCote;
    }

    public void setTypeEdition(ListeBean typeEdition) {
        this.typeEdition = typeEdition;
    }

    public ListeBean getTypeEdition() {
        return this.typeEdition;
    }

    public void setReliure(ListeBean reliure) {
        this.reliure = reliure;
    }

    public ListeBean getReliure() {
        return this.reliure;
    }

    public void setEtat(ListeBean etat) {
        this.etat = etat;
    }

    public ListeBean getEtat() {
        return this.etat;
    }

    public void setOrientation(ListeBean orientation) {
        this.orientation = orientation;
    }

    public ListeBean getOrientation() {
        return this.orientation;
    }

    public void setFormatEdition(ListeBean formatEdition) {
        this.formatEdition = formatEdition;
    }

    public ListeBean getFormatEdition() {
        return this.formatEdition;
    }

    public void setSensLecture(ListeBean sensLecture) {
        this.sensLecture = sensLecture;
    }

    public ListeBean getSensLecture() {
        return this.sensLecture;
    }
}
