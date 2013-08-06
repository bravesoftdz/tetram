package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.data.orm.annotations.Filter;
import org.tetram.bdtheque.data.orm.annotations.Filters;
import org.tetram.bdtheque.data.orm.annotations.OneToMany;
import org.tetram.bdtheque.data.orm.annotations.Order;
import org.tetram.bdtheque.data.orm.annotations.OrderBy;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.SERIES_TABLENAME)
public class SerieBean extends SerieBeanAbstract {

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<SerieBean> CREATOR = new Creator<SerieBean>() {
        @Override
        public SerieBean createFromParcel(Parcel source) {
            return new SerieBean(source);
        }

        @Override
        public SerieBean[] newArray(int size) {
            return new SerieBean[size];
        }
    };
    @OneToMany(mappedBy = "serie")
    @OrderBy(@Order(field = "genre.nom"))
    private final List<GenreSerieBean> genres = new ArrayList<GenreSerieBean>();
    @OneToMany(mappedBy = "serie")
    @Filters(@Filter(field = "metier", value = "0"))
    private final List<AuteurSerieBean> scenaristes = new ArrayList<AuteurSerieBean>();
    @OneToMany(mappedBy = "serie")
    @Filters(@Filter(field = "metier", value = "1"))
    private final List<AuteurSerieBean> dessinateurs = new ArrayList<AuteurSerieBean>();
    @OneToMany(mappedBy = "serie")
    @Filters(@Filter(field = "metier", value = "2"))
    private final List<AuteurSerieBean> coloristes = new ArrayList<AuteurSerieBean>();
    @OneToMany(mappedBy = "serie")
    private final List<AlbumLiteBean> albums = new ArrayList<AlbumLiteBean>();
    @Field(fieldName = DDLConstants.SERIES_SITEWEB)
    private URL siteWeb;
    @Field(fieldName = DDLConstants.EDITEURS_ID, nullable = false)
    private EditeurBean editeur;
    @Field(fieldName = DDLConstants.SERIES_SUJET)
    private String sujet;
    @Field(fieldName = DDLConstants.SERIES_NOTES)
    private String notes;

    public SerieBean(Parcel in) {
        super(in);
    }

    public SerieBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeValue(this.siteWeb);
        dest.writeTypedList(this.genres);
        dest.writeString(this.sujet);
        dest.writeString(this.notes);
        dest.writeTypedList(this.scenaristes);
        dest.writeTypedList(this.dessinateurs);
        dest.writeTypedList(this.coloristes);
        dest.writeTypedList(this.albums);
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.siteWeb = (URL) in.readValue(URL.class.getClassLoader());
        in.readTypedList(this.genres, GenreSerieBean.CREATOR);
        this.sujet = in.readString();
        this.notes = in.readString();
        in.readTypedList(this.scenaristes, AuteurSerieBean.CREATOR);
        in.readTypedList(this.dessinateurs, AuteurSerieBean.CREATOR);
        in.readTypedList(this.coloristes, AuteurSerieBean.CREATOR);
        in.readTypedList(this.albums, AlbumLiteBean.CREATOR);
        this.editeur = in.readParcelable(EditeurBean.class.getClassLoader());
    }

    public URL getSiteWeb() {
        return this.siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public List<GenreSerieBean> getGenres() {
        return this.genres;
    }

    public String getGenreList() {
        String s = "";
        for (GenreSerieBean genre : this.genres)
            s = StringUtils.ajoutString(s, genre.getGenre().getNom(), ", ");
        return s;
    }

    public List<AuteurSerieBean> getScenaristes() {
        return this.scenaristes;
    }

    public List<AuteurSerieBean> getDessinateurs() {
        return this.dessinateurs;
    }

    public List<AuteurSerieBean> getColoristes() {
        return this.coloristes;
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

    public List<AlbumLiteBean> getAlbums() {
        return this.albums;
    }

    public EditeurBean getEditeur() {
        return this.editeur;
    }

    public void setEditeur(EditeurBean editeur) {
        this.editeur = editeur;
    }

}
