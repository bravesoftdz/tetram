package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.data.factories.PersonneFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.PERSONNES_TABLENAME, primaryKey = DDLConstants.PERSONNES_ID, factoryClass = PersonneFactory.class)
public class PersonneBean extends PersonneLiteBean {

    private URL siteWeb;
    private String biographie;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<EditeurBean> CREATOR = new Creator<EditeurBean>() {
        @Override
        public EditeurBean createFromParcel(Parcel source) {
            return new EditeurBean(source);
        }

        @Override
        public EditeurBean[] newArray(int size) {
            return new EditeurBean[size];
        }
    };

    public PersonneBean(Parcel in) {
        super(in);
    }

    public PersonneBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        if (this.siteWeb == null)
            dest.writeValue(null);
        else
            dest.writeValue(this.siteWeb.toExternalForm());
        dest.writeString(this.biographie);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.siteWeb = (URL) in.readValue(URL.class.getClassLoader());
        this.biographie = in.readString();
    }

    public URL getSiteWeb() {
        return this.siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public String getBiographie() {
        return this.biographie;
    }

    public void setBiographie(String biographie) {
        this.biographie = biographie;
    }
}
