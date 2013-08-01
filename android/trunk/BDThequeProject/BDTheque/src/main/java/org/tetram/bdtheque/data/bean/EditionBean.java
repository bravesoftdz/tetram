package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.factories.EditionFactory;
import org.tetram.bdtheque.data.utils.DefaultBooleanValue;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Date;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITIONS_TABLENAME, factoryClass = EditionFactory.class)
public class EditionBean extends CommonBean {

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
    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.EDITIONS_ID, primaryKey = true)
    private UUID id;
    @Field(fieldName = DDLConstants.EDITIONS_ISBN)
    private String isbn;
    @Field(fieldName = DDLConstants.EDITEURS_ID, nullable = false)
    private EditeurBean editeur;
    @Field(fieldName = DDLConstants.COLLECTIONS_ID, nullable = true)
    private CollectionLiteBean collection;
    @Field(fieldName = DDLConstants.EDITIONS_ANNEEEDITION)
    private Integer annee;
    @Field(fieldName = DDLConstants.EDITIONS_STOCK)
    @DefaultBooleanValue(true)
    private boolean stock;
    @Field(fieldName = DDLConstants.EDITIONS_COULEUR)
    @DefaultBooleanValue(true)
    private boolean couleur;
    @Field(fieldName = DDLConstants.EDITIONS_DEDICACE)
    @DefaultBooleanValue(false)
    private boolean dedicace;
    @Field(fieldName = DDLConstants.EDITIONS_OFFERT)
    @DefaultBooleanValue(false)
    private boolean offert;
    @Field(fieldName = DDLConstants.EDITIONS_DATEACHAT)
    private Date dateAquisition;
    @Field(fieldName = DDLConstants.EDITIONS_NOTES)
    private String notes;
    @Field(fieldName = DDLConstants.EDITIONS_NOMBREDEPAGES)
    private Integer pages;
    @Field(fieldName = DDLConstants.EDITIONS_NUMEROPERSO)
    private String numeroPerso;
    @Field(fieldName = DDLConstants.EDITIONS_GRATUIT)
    @DefaultBooleanValue(false)
    private boolean gratuit;
    @Field(fieldName = DDLConstants.EDITIONS_PRIX)
    private Double prix;
    @Field(fieldName = DDLConstants.EDITIONS_ANNEECOTE)
    private Integer anneeCote;
    @Field(fieldName = DDLConstants.EDITIONS_PRIXCOTE)
    private Double prixCote;
    @Field(fieldName = DDLConstants.EDITIONS_TYPEEDITION, nullable = true)
    private ListeBean typeEdition;
    @Field(fieldName = DDLConstants.EDITIONS_RELIURE, nullable = true)
    private ListeBean reliure;
    @Field(fieldName = DDLConstants.EDITIONS_ETAT, nullable = true)
    private ListeBean etat;
    @Field(fieldName = DDLConstants.EDITIONS_ORIENTATION, nullable = true)
    private ListeBean orientation;
    @Field(fieldName = DDLConstants.EDITIONS_FORMATEDITION, nullable = true)
    private ListeBean formatEdition;
    @Field(fieldName = DDLConstants.EDITIONS_SENSLECTURE, nullable = true)
    private ListeBean sensLecture;

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
        this.stock = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.couleur = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.dedicace = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.offert = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.dateAquisition = (Date) in.readValue(Date.class.getClassLoader());
        this.notes = in.readString();
        this.pages = (Integer) in.readValue(Integer.class.getClassLoader());
        this.numeroPerso = in.readString();
        this.gratuit = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.anneeCote = (Integer) in.readValue(Integer.class.getClassLoader());
        this.prixCote = (Double) in.readValue(Double.class.getClassLoader());
        this.typeEdition = in.readParcelable(ListeBean.class.getClassLoader());
        this.reliure = in.readParcelable(ListeBean.class.getClassLoader());
        this.etat = in.readParcelable(ListeBean.class.getClassLoader());
        this.orientation = in.readParcelable(ListeBean.class.getClassLoader());
        this.formatEdition = in.readParcelable(ListeBean.class.getClassLoader());
        this.sensLecture = in.readParcelable(ListeBean.class.getClassLoader());
    }

    @Override
    public String toString() {
        String result = "";
        if (this.editeur != null)
            result = StringUtils.ajoutString(result, StringUtils.formatTitre(this.editeur.getNom()), " ");
        if (this.collection != null)
            result = StringUtils.ajoutString(result, StringUtils.formatTitre(this.collection.getNom()), " ", "(", ")");
        result = StringUtils.ajoutString(result, StringUtils.nonZero(this.annee), " ", "[", "]");
        result = StringUtils.ajoutString(result, StringUtils.formatISBN(this.isbn), " - ", "ISBN ");
        return result;
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public String getIsbn() {
        return this.isbn;
    }

    public void setIsbn(String isbn) {
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

    public ListeBean getTypeEdition() {
        return this.typeEdition;
    }

    public void setTypeEdition(ListeBean typeEdition) {
        this.typeEdition = typeEdition;
    }

    public ListeBean getReliure() {
        return this.reliure;
    }

    public void setReliure(ListeBean reliure) {
        this.reliure = reliure;
    }

    public ListeBean getEtat() {
        return this.etat;
    }

    public void setEtat(ListeBean etat) {
        this.etat = etat;
    }

    public ListeBean getOrientation() {
        return this.orientation;
    }

    public void setOrientation(ListeBean orientation) {
        this.orientation = orientation;
    }

    public ListeBean getFormatEdition() {
        return this.formatEdition;
    }

    public void setFormatEdition(ListeBean formatEdition) {
        this.formatEdition = formatEdition;
    }

    public ListeBean getSensLecture() {
        return this.sensLecture;
    }

    public void setSensLecture(ListeBean sensLecture) {
        this.sensLecture = sensLecture;
    }
}
