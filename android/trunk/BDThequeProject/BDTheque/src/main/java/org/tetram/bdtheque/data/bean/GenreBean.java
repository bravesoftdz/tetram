package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.factories.GenreFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.GENRES_TABLENAME, factoryClass = GenreFactory.class)
public class GenreBean extends CommonBean {

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
    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.GENRES_ID, primaryKey = true)
    private UUID id;
    @Field(fieldName = DDLConstants.GENRES_NOM)
    private String nom;

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

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

}
