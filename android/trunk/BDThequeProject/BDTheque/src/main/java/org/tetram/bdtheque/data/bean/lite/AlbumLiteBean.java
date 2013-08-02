package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.bean.enums.Notation;
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
@Entity(tableName = DDLConstants.ALBUMS_TABLENAME, factoryClass = AlbumLiteAbstractFactory.AlbumLiteFactory.class)
@BeanDaoClass(AlbumLiteDao.class)
public class AlbumLiteBean extends AlbumBeanAbstract implements TreeNodeBean {

    @Field(fieldName = DDLConstants.SERIES_ID, nullable = true)
    private SerieLiteBean serie;

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
        dest.writeParcelable(this.serie, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.serie = in.readParcelable(SerieLiteBean.class.getClassLoader());
    }

    @Override
    public String getTreeNodeText() {
        return getLabel(false, true);
    }

    @Override
    public Notation getTreeNodeRating() {
        return this.notation;
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

    public SerieLiteBean getSerie() {
        return this.serie;
    }

    public void setSerie(SerieLiteBean serie) {
        this.serie = serie;
    }

    public static class AlbumWithoutSerieLiteBean extends AlbumLiteBean {
        @Override
        public String getTreeNodeText() {
            return getLabel(false, false);
        }
    }

}
