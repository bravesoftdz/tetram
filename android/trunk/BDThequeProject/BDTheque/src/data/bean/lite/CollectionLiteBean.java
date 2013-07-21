package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.dao.lite.CollectionLiteDao;
import org.tetram.bdtheque.data.factories.lite.CollectionLiteFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.COLLECTIONS_TABLENAME, primaryKey = DDLConstants.COLLECTIONS_ID, factoryClass = CollectionLiteFactory.class)
@BeanDaoClass(CollectionLiteDao.class)
public class CollectionLiteBean extends CommonBean implements TreeNodeBean {

    @Field(fieldName = DDLConstants.COLLECTIONS_NOM)
    private String nom;
    @Field(fieldName = DDLConstants.EDITEURS_ID)
    private EditeurLiteBean editeur;

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

    public CollectionLiteBean(Parcel in) {
        super(in);
    }

    public CollectionLiteBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.nom);
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.nom = in.readString();
        this.editeur = in.readParcelable(EditeurLiteBean.class.getClassLoader());
    }

    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getLabel(boolean simple) {
        String result = StringUtils.formatTitre(this.nom);
        if (!simple)
            return StringUtils.ajoutString(result, StringUtils.formatTitre(this.editeur.getNom()), " ", "(", ")");
        else
            return result;
    }

    @SuppressWarnings("UnusedDeclaration")
    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }

    @Override
    public String getTreeNodeText() {
        return getLabel(true);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }
}
