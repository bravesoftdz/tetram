package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.factories.AlbumFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, primaryKey = DDLConstants.ALBUMS_ID, factoryClass = AlbumFactory.class)
@BeanDaoClass(AlbumDao.class)
public class AlbumBean extends AlbumLiteBean {

    @Field(fieldName = DDLConstants.ALBUMS_SUJET)
    private String sujet;
    @Field(fieldName = DDLConstants.ALBUMS_NOTES)
    private String notes;
    @Field(fieldName = DDLConstants.SERIES_ID)
    private SerieBean serie;
    private final List<AuteurBean> scenaristes = new ArrayList<>();
    private final List<AuteurBean> dessinateurs = new ArrayList<>();
    private final List<AuteurBean> coloristes = new ArrayList<>();
    private final List<EditionBean> editions = new ArrayList<>();

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<AlbumBean> CREATOR = new Creator<AlbumBean>() {
        @Override
        public AlbumBean createFromParcel(Parcel source) {
            return new AlbumBean(source);
        }

        @Override
        public AlbumBean[] newArray(int size) {
            return new AlbumBean[size];
        }
    };

    public AlbumBean() {
        super();
    }

    public AlbumBean(Parcel in) {
        super(in);
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.serie, flags);
        dest.writeString(this.sujet);
        dest.writeString(this.notes);
        dest.writeTypedList(this.scenaristes);
        dest.writeTypedList(this.dessinateurs);
        dest.writeTypedList(this.coloristes);
        dest.writeTypedList(this.editions);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.serie = in.readParcelable(SerieBean.class.getClassLoader());
        this.sujet = in.readString();
        this.notes = in.readString();
        in.readTypedList(this.scenaristes, AuteurBean.CREATOR);
        in.readTypedList(this.dessinateurs, AuteurBean.CREATOR);
        in.readTypedList(this.coloristes, AuteurBean.CREATOR);
        in.readTypedList(this.editions, EditionBean.CREATOR);
    }

    @Override
    public SerieBean getSerie() {
        return this.serie;
    }

    @SuppressWarnings({"OverloadedMethodsWithSameNumberOfParameters", "MethodOverloadsMethodOfSuperclass"})
    public void setSerie(SerieBean serie) {
        this.serie = serie;
    }

    public String getSujet() {
        return this.sujet;
    }

    public void setSujet(String sujet) {
        this.sujet = sujet;
    }

    public String getNotes() {
        return this.notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public List<AuteurBean> getScenaristes() {
        return this.scenaristes;
    }

    public List<AuteurBean> getDessinateurs() {
        return this.dessinateurs;
    }

    public List<AuteurBean> getColoristes() {
        return this.coloristes;
    }

    public List<EditionBean> getEditions() {
        return this.editions;
    }
}
