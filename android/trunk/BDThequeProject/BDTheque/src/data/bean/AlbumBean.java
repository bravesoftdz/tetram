package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.factories.AlbumFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

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
}
