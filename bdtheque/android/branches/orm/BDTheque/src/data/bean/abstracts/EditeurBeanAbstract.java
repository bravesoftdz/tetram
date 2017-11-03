package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
public abstract class EditeurBeanAbstract extends CommonBean {
    @Field(fieldName = DDLConstants.EDITEURS_NOM)
    protected String nom;

    public EditeurBeanAbstract(Parcel in) {
        super(in);
    }

    public EditeurBeanAbstract() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.nom);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.nom = in.readString();
    }

    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
