package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.EditeurLiteBean;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class CollectionBeanAbstract extends CommonBean {

    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.COLLECTIONS_ID, primaryKey = true)
    protected UUID id;
    @Field(fieldName = DDLConstants.COLLECTIONS_NOM)
    protected String nom;
    @Field(fieldName = DDLConstants.EDITEURS_ID, nullable = false)
    protected EditeurLiteBean editeur;

    public CollectionBeanAbstract(Parcel in) {
        super(in);
    }

    public CollectionBeanAbstract() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.nom);
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.nom = in.readString();
        this.editeur = in.readParcelable(EditeurLiteBean.class.getClassLoader());
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public EditeurLiteBean getEditeur() {
        return this.editeur;
    }

    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }
}
