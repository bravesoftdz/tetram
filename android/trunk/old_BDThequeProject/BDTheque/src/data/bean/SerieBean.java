package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
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
@Entity(tableName = DDLConstants.SERIES_TABLENAME, primaryKey = DDLConstants.SERIES_ID, factoryClass = SerieFactory.class)
@BeanDaoClass(SerieDao.class)
public class SerieBean extends SerieLiteBean {

    @Field(fieldName = DDLConstants.SERIES_SITEWEB)
    private URL siteWeb;
    private final List<GenreBean> genres = new ArrayList<>();

    private final List<AuteurBean> scenaristes = new ArrayList<>();
    private final List<AuteurBean> dessinateurs = new ArrayList<>();
    private final List<AuteurBean> coloristes = new ArrayList<>();

    @Field(fieldName = DDLConstants.EDITEURS_ID)
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
        in.readTypedList(this.scenaristes, AuteurBean.CREATOR);
        in.readTypedList(this.dessinateurs, AuteurBean.CREATOR);
        in.readTypedList(this.coloristes, AuteurBean.CREATOR);
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

    public List<AuteurBean> getScenaristes() {
        return this.scenaristes;
    }

    public List<AuteurBean> getDessinateurs() {
        return this.dessinateurs;
    }

    public List<AuteurBean> getColoristes() {
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

    @Override
    public EditeurBean getEditeur() {
        return this.editeur;
    }

    @SuppressWarnings("MethodOverloadsMethodOfSuperclass")
    public void setEditeur(EditeurBean editeur) {
        this.editeur = editeur;
    }

}
