package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.dao.GenreSerieDao;
import org.tetram.bdtheque.data.factories.GenreSerieFactory;
import org.tetram.bdtheque.data.orm.annotations.BeanDaoClass;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.GENRESERIES_TABLENAME, factoryClass = GenreSerieFactory.class)
@BeanDaoClass(GenreSerieDao.class)
public class GenreSerieBean extends CommonBean {
    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<GenreSerieBean> CREATOR = new Creator<GenreSerieBean>() {
        @Override
        public GenreSerieBean createFromParcel(Parcel source) {
            return new GenreSerieBean(source);
        }

        @Override
        public GenreSerieBean[] newArray(int size) {
            return new GenreSerieBean[size];
        }
    };
    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.GENRESERIES_ID, primaryKey = true)
    private UUID id;
    @Field(fieldName = DDLConstants.GENRES_ID, nullable = false)
    private GenreBean genre;
    @Field(fieldName = DDLConstants.SERIES_ID, nullable = false)
    private SerieLiteBean serie;

    public GenreSerieBean(Parcel in) {
        super(in);
    }

    public GenreSerieBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.genre, flags);
        dest.writeParcelable(this.serie, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.genre = in.readParcelable(GenreBean.class.getClassLoader());
        this.serie = in.readParcelable(SerieLiteBean.class.getClassLoader());
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public SerieLiteBean getSerie() {
        return this.serie;
    }

    public void setSerie(SerieLiteBean serie) {
        this.serie = serie;
    }

    public GenreBean getGenre() {
        return this.genre;
    }

    public void setGenre(GenreBean genre) {
        this.genre = genre;
    }
}
