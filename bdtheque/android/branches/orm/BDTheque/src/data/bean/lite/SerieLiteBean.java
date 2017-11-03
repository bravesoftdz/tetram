package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;
import android.os.Parcelable;

import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.dao.lite.SerieLiteDao;
import org.tetram.bdtheque.data.factories.lite.SerieLiteFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.gui.fragments.FicheSerieFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@ShowFragmentClass(FicheSerieFragment.class)
@Entity(tableName = DDLConstants.SERIES_TABLENAME, primaryKey = DDLConstants.SERIES_ID, factoryClass = SerieLiteFactory.class)
@BeanDaoClass(SerieLiteDao.class)
public class SerieLiteBean extends SerieBeanAbstract implements TreeNodeBean {

    @Field(fieldName = DDLConstants.EDITEURS_ID, nullable = false)
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
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.editeur = in.readParcelable(EditeurLiteBean.class.getClassLoader());
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

    @Override
    public Float getTreeNodeRating() {
        return (float) this.notation.getValue();
    }

    public EditeurLiteBean getEditeur() {
        return this.editeur;
    }

    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }

}
