package org.tetram.bdtheque.data.lite.bean;

import android.os.Parcel;
import android.os.Parcelable;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.lite.EditeurLiteFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITEURS_TABLENAME, primaryKey = DDLConstants.EDITEURS_ID, factoryClass = EditeurLiteFactory.class)
public class EditeurLiteBean extends CommonBean implements TreeNodeBean {
    private String nom;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Parcelable.Creator<EditeurLiteBean> CREATOR = new Parcelable.Creator<EditeurLiteBean>() {
        @Override
        public EditeurLiteBean createFromParcel(Parcel source) {
            return new EditeurLiteBean(source);
        }

        @Override
        public EditeurLiteBean[] newArray(int size) {
            return new EditeurLiteBean[size];
        }
    };

    public EditeurLiteBean(Parcel in) {
        super(in);
    }

    public EditeurLiteBean() {
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

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }

}
