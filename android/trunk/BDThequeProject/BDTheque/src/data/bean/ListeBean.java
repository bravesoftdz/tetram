package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.factories.ListeFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.LISTES_TABLENAME, primaryKey = DDLConstants.LISTES_ID, factoryClass = ListeFactory.class)
public class ListeBean extends CommonBean {
    public enum ListeCategorie {
        ETAT(1),
        RELIURE(2),
        TYPE_EDITION(3),
        ORIENTATION(4),
        FORMAT_EDITION(5),
        CATEGORIE_IMAGE(6),
        CATEGORIE_PARABD(7),
        SENS_LECTURE(8);

        private final int value;

        ListeCategorie(int value) {
            this.value = value;
        }

        @Nullable
        public static ListeCategorie fromValue(int value) {
            for (ListeCategorie type : values())
                if (type.value == value) return type;
            return null;
        }

        public int getValue() {
            return this.value;
        }
    }

    private Integer ref;
    private ListeCategorie categorie;
    private Integer ordre;
    private Integer defaut;
    private String libelle;

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
