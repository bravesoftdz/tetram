package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.Notation;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.dao.lite.AlbumLiteDao;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteAbstractFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.gui.fragments.FicheAlbumFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@ShowFragmentClass(FicheAlbumFragment.class)
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, primaryKey = DDLConstants.ALBUMS_ID, factoryClass = AlbumLiteAbstractFactory.AlbumLiteFactory.class)
@BeanDaoClass(AlbumLiteDao.class)
public class AlbumLiteBean extends CommonBean implements TreeNodeBean {

    public static class AlbumWithoutSerieLiteBean extends AlbumLiteBean {
        @Override
        public String getTreeNodeText() {
            return getLabel(false, false);
        }
    }

    @Field(fieldName = DDLConstants.ALBUMS_TITRE)
    private String titre;
    @Field(fieldName = DDLConstants.ALBUMS_TOME)
    private Integer tome;
    @Field(fieldName = DDLConstants.ALBUMS_TOMEDEBUT)
    private Integer tomeDebut;
    @Field(fieldName = DDLConstants.ALBUMS_TOMEFIN)
    private Integer tomeFin;
    @Field(fieldName = DDLConstants.ALBUMS_HORSSERIE)
    private Boolean horsSerie;
    @Field(fieldName = DDLConstants.ALBUMS_INTEGRALE)
    private Boolean integrale;
    @Field(fieldName = DDLConstants.ALBUMS_MOISPARUTION)
    private Integer moisParution;
    @Field(fieldName = DDLConstants.ALBUMS_ANNEEPARUTION)
    private Integer anneeParution;
    @Field(fieldName = DDLConstants.ALBUMS_NOTATION)
    private Notation notation = Notation.PAS_NOTE;
    @Field(fieldName = DDLConstants.SERIES_ID)
    private SerieLiteBean serie;
    @Field(fieldName = DDLConstants.ALBUMS_ACHAT)
    private Boolean achat;
    @Field(fieldName = DDLConstants.ALBUMS_COMPLET)
    private Boolean complet;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<AlbumLiteBean> CREATOR = new Creator<AlbumLiteBean>() {
        @Override
        public AlbumLiteBean createFromParcel(Parcel source) {
            return new AlbumLiteBean(source);
        }

        @Override
        public AlbumLiteBean[] newArray(int size) {
            return new AlbumLiteBean[size];
        }
    };

    public AlbumLiteBean(Parcel in) {
        super(in);
    }

    public AlbumLiteBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.titre);
        dest.writeValue(this.tome);
        dest.writeValue(this.tomeDebut);
        dest.writeValue(this.tomeFin);
        dest.writeValue(this.horsSerie);
        dest.writeValue(this.integrale);
        dest.writeValue(this.moisParution);
        dest.writeValue(this.anneeParution);
        dest.writeValue(this.notation);
        dest.writeParcelable(this.serie, flags);
        dest.writeValue(this.achat);
        dest.writeValue(this.complet);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.titre = in.readString();
        this.tome = (Integer) in.readValue(Integer.class.getClassLoader());
        this.tomeDebut = (Integer) in.readValue(Integer.class.getClassLoader());
        this.tomeFin = (Integer) in.readValue(Integer.class.getClassLoader());
        this.horsSerie = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.integrale = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.moisParution = (Integer) in.readValue(Integer.class.getClassLoader());
        this.anneeParution = (Integer) in.readValue(Integer.class.getClassLoader());
        this.notation = (Notation) in.readValue(Notation.class.getClassLoader());
        this.serie = in.readParcelable(SerieLiteBean.class.getClassLoader());
        this.achat = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.complet = (Boolean) in.readValue(Boolean.class.getClassLoader());
    }

    public String getLabel(boolean simple, boolean avecSerie) {
        return StringUtils.formatTitreAlbum(
                simple,
                avecSerie,
                this.titre,
                (this.serie != null) ? this.serie.getTitre() : null,
                this.tome,
                this.tomeDebut,
                this.tomeFin,
                this.integrale,
                this.horsSerie);
    }

    @Override
    public String getTreeNodeText() {
        return getLabel(false, true);
    }

    @Override
    public Float getTreeNodeRating() {
        return (float) this.notation.getValue();
    }

    public String getTitre() {
        return this.titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public Integer getTome() {
        return this.tome;
    }

    public void setTome(Integer tome) {
        this.tome = tome;
    }

    public Integer getTomeDebut() {
        return this.tomeDebut;
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut = tomeDebut;
    }

    public Integer getTomeFin() {
        return this.tomeFin;
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin = tomeFin;
    }

    public Boolean isHorsSerie() {
        return this.horsSerie;
    }

    public void setHorsSerie(Boolean horsSerie) {
        this.horsSerie = horsSerie;
    }

    public Boolean isIntegrale() {
        return this.integrale;
    }

    public void setIntegrale(Boolean integrale) {
        this.integrale = integrale;
    }

    public Integer getMoisParution() {
        return this.moisParution;
    }

    public void setMoisParution(Integer moisParution) {
        this.moisParution = moisParution;
    }

    public Integer getAnneeParution() {
        return this.anneeParution;
    }

    public void setAnneeParution(Integer anneeParution) {
        this.anneeParution = anneeParution;
    }

    public Notation getNotation() {
        return this.notation;
    }

    public void setNotation(Notation notation) {
        this.notation = notation;
    }

    public SerieLiteBean getSerie() {
        return this.serie;
    }

    public void setSerie(SerieLiteBean serie) {
        this.serie = serie;
    }

    public Boolean isAchat() {
        return this.achat;
    }

    public void setAchat(Boolean achat) {
        this.achat = achat;
    }

    public Boolean isComplet() {
        return this.complet;
    }

    public void setComplet(Boolean complet) {
        this.complet = complet;
    }
}
