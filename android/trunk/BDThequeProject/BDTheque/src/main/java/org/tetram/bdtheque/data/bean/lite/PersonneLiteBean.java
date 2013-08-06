package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.abstracts.PersonneBeanAbstract;
import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.gui.fragments.FichePersonneFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@ShowFragmentClass(FichePersonneFragment.class)
@Entity(tableName = DDLConstants.PERSONNES_TABLENAME, factoryClass = PersonneLiteFactory.class)
public class PersonneLiteBean extends PersonneBeanAbstract implements TreeNodeBean {

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<PersonneLiteBean> CREATOR = new Creator<PersonneLiteBean>() {
        @Override
        public PersonneLiteBean createFromParcel(Parcel source) {
            return new PersonneLiteBean(source);
        }

        @Override
        public PersonneLiteBean[] newArray(int size) {
            return new PersonneLiteBean[size];
        }
    };

    public PersonneLiteBean(Parcel in) {
        super(in);
    }

    public PersonneLiteBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
    }

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Override
    public Notation getTreeNodeRating() {
        return Notation.PAS_NOTE;
    }

}
