package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.gui.activities.fragments.FicheAlbumFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@ShowFragmentClass(FicheAlbumFragment.class)
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, primaryKey = DDLConstants.ALBUMS_ID, factoryClass = AlbumLiteFactory.class)
public class AlbumLiteBean extends CommonBean implements TreeNodeBean {

    private String titre;
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private Boolean horsSerie;
    private Boolean integrale;
    private Integer moisParution, anneeParution;
    private Integer notation;
    private SerieLiteBean serie;
    private Boolean achat, complet;

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
        this.notation = (Integer) in.readValue(Integer.class.getClassLoader());
        this.serie = in.readParcelable(SerieLiteBean.class.getClassLoader());
        this.achat = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.complet = (Boolean) in.readValue(Boolean.class.getClassLoader());
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

    public Integer getNotation() {
        return this.notation;
    }

    public void setNotation(Integer notation) {
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

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return (this.notation == null) ? null : Float.valueOf(this.notation);
    }
}
