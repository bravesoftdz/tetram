package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;

@SuppressWarnings("UnusedDeclaration")
public class AuteurBean extends CommonBean {

    private PersonneLiteBean personne;
    private AuteurMetier metier;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<AuteurBean> CREATOR = new Creator<AuteurBean>() {
        @Override
        public AuteurBean createFromParcel(Parcel source) {
            return new AuteurBean(source);
        }

        @Override
        public AuteurBean[] newArray(int size) {
            return new AuteurBean[size];
        }
    };

    public AuteurBean(Parcel in) {
        super(in);
    }

    public AuteurBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeSerializable(this.metier);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.metier = (AuteurMetier) in.readSerializable();
    }

    @Override
    public String toString() {
        return this.personne.getTreeNodeText();
    }

    public PersonneLiteBean getPersonne() {
        return this.personne;
    }

    public void setPersonne(PersonneLiteBean personne) {
        this.personne = personne;
    }

    public AuteurMetier getMetier() {
        return this.metier;
    }

    public void setMetier(AuteurMetier metier) {
        this.metier = metier;
    }
}
