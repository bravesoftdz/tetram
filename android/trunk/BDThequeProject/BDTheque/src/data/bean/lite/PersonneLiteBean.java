package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.PersonneLiteFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.gui.activities.fragments.FichePersonneFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@ShowFragmentClass(FichePersonneFragment.class)
@Entity(tableName = DDLConstants.PERSONNES_TABLENAME, primaryKey = DDLConstants.PERSONNES_ID, factoryClass = PersonneLiteFactory.class)
public class PersonneLiteBean extends CommonBean implements TreeNodeBean {

    private String nom;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<CollectionLiteBean> CREATOR = new Creator<CollectionLiteBean>() {
        @Override
        public CollectionLiteBean createFromParcel(Parcel source) {
            return new CollectionLiteBean(source);
        }

        @Override
        public CollectionLiteBean[] newArray(int size) {
            return new CollectionLiteBean[size];
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
        dest.writeString(this.nom);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.nom = in.readString();
    }

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }

    @SuppressWarnings("UnusedDeclaration")
    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
