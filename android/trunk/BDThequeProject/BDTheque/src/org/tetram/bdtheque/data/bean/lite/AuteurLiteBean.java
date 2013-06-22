package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.AuteurLiteFactory;
import org.tetram.bdtheque.gui.activities.fragments.FicheAuteurFragment;
import org.tetram.bdtheque.utils.BeanFactoryClass;
import org.tetram.bdtheque.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@BeanFactoryClass(AuteurLiteFactory.class)
@ShowFragmentClass(FicheAuteurFragment.class)
public class AuteurLiteBean extends CommonBean implements TreeNodeBean {

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

    public AuteurLiteBean(Parcel in) {
        super(in);
    }

    public AuteurLiteBean() {
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
