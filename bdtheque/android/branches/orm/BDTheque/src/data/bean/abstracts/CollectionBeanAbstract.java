package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.lite.EditeurLiteBean;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
public abstract class CollectionBeanAbstract extends CommonBean {
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
