package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.ImageBean;
import org.tetram.bdtheque.data.bean.ListeBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.factories.EditionFactory;
import org.tetram.bdtheque.data.factories.EditionLiteFactory;
import org.tetram.bdtheque.data.utils.DefaultBooleanValue;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITIONS_TABLENAME, factoryClass = EditionLiteFactory.class)
public class EditionLiteBean extends CommonBean {

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<EditionLiteBean> CREATOR = new Creator<EditionLiteBean>() {
        @Override
        public EditionLiteBean createFromParcel(Parcel source) {
            return new EditionLiteBean(source);
        }

        @Override
        public EditionLiteBean[] newArray(int size) {
            return new EditionLiteBean[size];
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

    public EditionLiteBean(Parcel in) {
        super(in);
    }

    public EditionLiteBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.isbn);
        dest.writeParcelable(this.editeur, flags);
        dest.writeParcelable(this.collection, flags);
        dest.writeValue(this.annee);
        dest.writeValue(this.stock);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.isbn = in.readString();
        this.editeur = in.readParcelable(EditeurBean.class.getClassLoader());
        this.collection = in.readParcelable(CollectionLiteBean.class.getClassLoader());
        this.annee = (Integer) in.readValue(Integer.class.getClassLoader());
        this.stock = (Boolean) in.readValue(Boolean.class.getClassLoader());
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

    public Integer getAnnee() {
        return this.annee;
    }

    public void setAnnee(Integer annee) {
        this.annee = annee;
    }

}
