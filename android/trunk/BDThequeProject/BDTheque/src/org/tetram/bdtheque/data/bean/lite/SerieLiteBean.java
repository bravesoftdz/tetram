package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;
import android.os.Parcelable;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.SerieLiteFactory;
import org.tetram.bdtheque.gui.activities.fragments.FicheSerieFragment;
import org.tetram.bdtheque.utils.BeanFactoryClass;
import org.tetram.bdtheque.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@BeanFactoryClass(SerieLiteFactory.class)
@ShowFragmentClass(FicheSerieFragment.class)
public class SerieLiteBean extends CommonBean implements TreeNodeBean {

    private String titre;
    private CollectionLiteBean collection;
    private EditeurLiteBean editeur;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Parcelable.Creator<SerieLiteBean> CREATOR = new Parcelable.Creator<SerieLiteBean>() {
        @Override
        public SerieLiteBean createFromParcel(Parcel source) {
            return new SerieLiteBean(source);
        }

        @Override
        public SerieLiteBean[] newArray(int size) {
            return new SerieLiteBean[size];
        }
    };

    public SerieLiteBean(Parcel in) {
        super(in);
    }

    public SerieLiteBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.titre);
        dest.writeParcelable(this.collection, flags);
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.titre = in.readString();
        this.collection = in.readParcelable(CollectionLiteBean.class.getClassLoader());
        this.editeur = in.readParcelable(EditeurLiteBean.class.getClassLoader());
    }

    public String getTitre() {
        return this.titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    private String chaineAffichage(boolean simple) {
        String result;
        if (simple)
            result = this.titre;
        else
            result = StringUtils.formatTitre(this.titre);

        String s = StringUtils.ajoutString("", StringUtils.formatTitre(this.editeur.getNom()), " ");
        if (this.collection != null)
            s = StringUtils.ajoutString(s, StringUtils.formatTitre(this.collection.getNom()), " - ");
        return StringUtils.ajoutString(result, s, " ", "(", ")");
    }

    @Override
    public String getTreeNodeText() {
        return chaineAffichage(false);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }

    public void setCollection(CollectionLiteBean collection) {
        this.collection = collection;
    }

    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }
}
