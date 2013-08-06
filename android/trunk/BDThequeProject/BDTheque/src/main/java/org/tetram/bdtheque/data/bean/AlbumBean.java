package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.factories.AlbumFactory;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.data.orm.annotations.OneToMany;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, factoryClass = AlbumFactory.class)
public class AlbumBean extends AlbumBeanAbstract {

    @Field(fieldName = DDLConstants.ALBUMS_SUJET)
    private String sujet;
    @Field(fieldName = DDLConstants.ALBUMS_NOTES)
    private String notes;
    @Field(fieldName = DDLConstants.SERIES_ID, nullable = true)
    private SerieBean serie;
    @OneToMany(mappedBy = "album", filtered = "metier = 0")
    private final List<AuteurAlbumBean> scenaristes = new ArrayList<AuteurAlbumBean>();
    @OneToMany(mappedBy = "album", filtered = "metier = 1")
    private final List<AuteurAlbumBean> dessinateurs = new ArrayList<AuteurAlbumBean>();
    @OneToMany(mappedBy = "album", filtered = "metier = 2")
    private final List<AuteurAlbumBean> coloristes = new ArrayList<AuteurAlbumBean>();
    @OneToMany(mappedBy = "album")
    private final List<EditionBean> editions = new ArrayList<EditionBean>();

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
        in.readTypedList(this.scenaristes, AuteurAlbumBean.CREATOR);
        in.readTypedList(this.dessinateurs, AuteurAlbumBean.CREATOR);
        in.readTypedList(this.coloristes, AuteurAlbumBean.CREATOR);
        in.readTypedList(this.editions, EditionBean.CREATOR);
    }

    public SerieBean getSerie() {
        return this.serie;
    }

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

    public List<AuteurAlbumBean> getScenaristes() {
        return this.scenaristes;
    }

    public List<AuteurAlbumBean> getDessinateurs() {
        return this.dessinateurs;
    }

    public List<AuteurAlbumBean> getColoristes() {
        return this.coloristes;
    }

    public List<EditionBean> getEditions() {
        return this.editions;
    }
}
