package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.AuteurBeanAbstract;
import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.AuteurAlbumDao;
import org.tetram.bdtheque.data.factories.AuteurAlbumFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.AUTEURS_ALBUMS_TABLENAME, primaryKey = DDLConstants.AUTEURS_ALBUMS_ID, factoryClass = AuteurAlbumFactory.class)
@BeanDaoClass(AuteurAlbumDao.class)
public class AuteurAlbumBean extends AuteurBeanAbstract {

    @Field(fieldName = DDLConstants.ALBUMS_ID, nullable = false)
    private AlbumLiteBean album;
    @Field(fieldName = DDLConstants.AUTEURS_ALBUMS_METIER)
    private AuteurMetier metier;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<AuteurAlbumBean> CREATOR = new Creator<AuteurAlbumBean>() {
        @Override
        public AuteurAlbumBean createFromParcel(Parcel source) {
            return new AuteurAlbumBean(source);
        }

        @Override
        public AuteurAlbumBean[] newArray(int size) {
            return new AuteurAlbumBean[size];
        }
    };

    public AuteurAlbumBean(Parcel in) {
        super(in);
    }

    public AuteurAlbumBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.album, flags);
        dest.writeSerializable(this.metier);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.album = in.readParcelable(AlbumLiteBean.class.getClassLoader());
        this.metier = (AuteurMetier) in.readSerializable();
    }

    public AlbumLiteBean getAlbum() {
        return this.album;
    }

    public void setAlbum(AlbumLiteBean album) {
        this.album = album;
    }

    @Override
    public AuteurMetier getMetier() {
        return this.metier;
    }

    @Override
    public void setMetier(AuteurMetier metier) {
        this.metier = metier;
    }
}
