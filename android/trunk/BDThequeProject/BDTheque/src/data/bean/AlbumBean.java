package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.AlbumFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, primaryKey = DDLConstants.ALBUMS_ID, factoryClass = AlbumFactory.class)
public class AlbumBean extends AlbumLiteBean {

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
    private String sujet;
    private String notes;
    private SerieBean serie;
    private final List<AuteurBean> scenaristes = new ArrayList<>();
    private final List<AuteurBean> dessinateurs = new ArrayList<>();
    private final List<AuteurBean> coloristes = new ArrayList<>();

    public AlbumBean() {
        super();
    }

    public AlbumBean(Parcel in) {
        super(in);
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
    }

    @Override
    public SerieBean getSerie() {
        return this.serie;
    }

    @Override
    public void setSerie(SerieLiteBean serie) {
        throw new UnsupportedOperationException();
    }

    @SuppressWarnings("OverloadedMethodsWithSameNumberOfParameters")
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
}
