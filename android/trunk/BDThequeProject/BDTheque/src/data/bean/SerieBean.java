package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.SerieFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.SERIES_TABLENAME, primaryKey = DDLConstants.SERIES_ID, factoryClass = SerieFactory.class)
public class SerieBean extends SerieLiteBean {

    private URL siteWeb;

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
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
    }

    public URL getSiteWeb() {
        return this.siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }
}
