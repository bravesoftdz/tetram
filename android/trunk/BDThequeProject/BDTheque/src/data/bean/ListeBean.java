package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.bean.enums.ListeCategorie;
import org.tetram.bdtheque.data.dao.ListeDao;
import org.tetram.bdtheque.data.factories.ListeFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.LISTES_TABLENAME, factoryClass = ListeFactory.class)
@BeanDaoClass(ListeDao.class)
public class ListeBean extends CommonBean {

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<ListeBean> CREATOR = new Creator<ListeBean>() {
        @Override
        public ListeBean createFromParcel(Parcel source) {
            return new ListeBean(source);
        }

        @Override
        public ListeBean[] newArray(int size) {
            return new ListeBean[size];
        }
    };
    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.LISTES_ID, primaryKey = true)
    private UUID id;
    @Field(fieldName = DDLConstants.LISTES_REF)
    private Integer ref;
    @Field(fieldName = DDLConstants.LISTES_CATEGORIE)
    private ListeCategorie categorie;
    @Field(fieldName = DDLConstants.LISTES_ORDRE)
    private Integer ordre;
    @Field(fieldName = DDLConstants.LISTES_DEFAUT)
    private Integer defaut;
    @Field(fieldName = DDLConstants.LISTES_LIBELLE)
    private String libelle;

    public ListeBean(Parcel in) {
        super(in);
    }

    public ListeBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeValue(this.ref);
        dest.writeValue(this.categorie);
        dest.writeValue(this.ordre);
        dest.writeValue(this.defaut);
        dest.writeValue(this.libelle);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        final ClassLoader integerClassLoader = Integer.class.getClassLoader();

        this.ref = (Integer) in.readValue(integerClassLoader);
        this.categorie = (ListeCategorie) in.readValue(ListeCategorie.class.getClassLoader());
        this.ordre = (Integer) in.readValue(integerClassLoader);
        this.defaut = (Integer) in.readValue(integerClassLoader);
        this.libelle = (String) in.readValue(String.class.getClassLoader());
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    @Override
    public String toString() {
        return StringUtils.formatTitre(this.libelle);
    }

    public Integer getRef() {
        return this.ref;
    }

    public void setRef(Integer ref) {
        this.ref = ref;
    }

    public ListeCategorie getCategorie() {
        return this.categorie;
    }

    public void setCategorie(ListeCategorie categorie) {
        this.categorie = categorie;
    }

    public Integer getOrdre() {
        return this.ordre;
    }

    public void setOrdre(Integer ordre) {
        this.ordre = ordre;
    }

    public Integer getDefaut() {
        return this.defaut;
    }

    public void setDefaut(Integer defaut) {
        this.defaut = defaut;
    }

    public String getLibelle() {
        return this.libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

}
