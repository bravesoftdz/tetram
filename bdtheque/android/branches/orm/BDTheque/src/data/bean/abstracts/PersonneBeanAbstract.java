package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
public abstract class PersonneBeanAbstract extends CommonBean {
    @Field(fieldName = DDLConstants.PERSONNES_NOM)
    protected String nom;

    public PersonneBeanAbstract(Parcel in) {
        super(in);
    }

    public PersonneBeanAbstract() {
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
