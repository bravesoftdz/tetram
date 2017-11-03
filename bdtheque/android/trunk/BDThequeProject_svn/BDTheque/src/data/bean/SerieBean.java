package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.data.factories.SerieFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.SERIES_TABLENAME, factoryClass = SerieFactory.class)
@BeanDaoClass(SerieDao.class)
public class SerieBean extends SerieBeanAbstract {

    @Field(fieldName = DDLConstants.SERIES_SITEWEB)
    private URL siteWeb;
    private final List<GenreBean> genres = new ArrayList<>();

    private final List<AuteurSerieBean> scenaristes = new ArrayList<>();
    private final List<AuteurSerieBean> dessinateurs = new ArrayList<>();
    private final List<AuteurSerieBean> coloristes = new ArrayList<>();

    @Field(fieldName = DDLConstants.EDITEURS_ID, nullable = false)
    private EditeurBean editeur;

    private final List<AlbumLiteBean> albums = new ArrayList<>();

    @Field(fieldName = DDLConstants.SERIES_SUJET)
    private String sujet;
    @Field(fieldName = DDLConstants.SERIES_NOTES)
    private String notes;

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

    public SerieBean(Parcel in) {
        super(in);
    }

    public SerieBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        if (this.siteWeb == null)
            dest.writeValue(null);
        else
            dest.writeValue(this.siteWeb.toExternalForm());
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
        in.readTypedList(this.genres, GenreBean.CREATOR);
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

    public List<GenreBean> getGenres() {
        return this.genres;
    }

    public String getGenreList() {
        String s = "";
        for (GenreBean genre : this.genres)
            s = StringUtils.ajoutString(s, genre.getNom(), ", ");
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
