package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
public abstract class AuteurBeanAbstract extends CommonBean {

    @Field(fieldName = DDLConstants.PERSONNES_ID, nullable = false)
    private PersonneLiteBean personne;

    public AuteurBeanAbstract(Parcel in) {
        super(in);
    }

    public AuteurBeanAbstract() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.personne, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.personne = in.readParcelable(PersonneLiteBean.class.getClassLoader());
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

    public abstract AuteurMetier getMetier();

    public abstract void setMetier(AuteurMetier metier);
}
