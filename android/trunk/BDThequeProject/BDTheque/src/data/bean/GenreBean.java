package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.factories.GenreFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.GENRES_TABLENAME, primaryKey = DDLConstants.GENRES_ID, factoryClass = GenreFactory.class)
public class GenreBean extends CommonBean {

    private String nom;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<GenreBean> CREATOR = new Creator<GenreBean>() {
        @Override
        public GenreBean createFromParcel(Parcel source) {
            return new GenreBean(source);
        }

        @Override
        public GenreBean[] newArray(int size) {
            return new GenreBean[size];
        }
    };

    public GenreBean(Parcel in) {
        super(in);
    }

    public GenreBean() {
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

}
