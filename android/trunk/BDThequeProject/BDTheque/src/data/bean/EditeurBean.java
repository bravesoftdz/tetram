package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.EditeurLiteBean;
import org.tetram.bdtheque.data.factories.EditeurFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.net.URL;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITEURS_TABLENAME, primaryKey = DDLConstants.EDITEURS_ID, factoryClass = EditeurFactory.class)
public class EditeurBean extends EditeurLiteBean {

    @Field(fieldName = DDLConstants.EDITEURS_SITEWEB)
    private URL siteWeb;

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

    public EditeurBean(Parcel in) {
        super(in);
    }

    public EditeurBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        if (this.siteWeb == null)
            dest.writeValue(null);
        else
            dest.writeValue(this.siteWeb.toExternalForm());
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.siteWeb = (URL) in.readValue(URL.class.getClassLoader());
    }

    public URL getSiteWeb() {
        return this.siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }
}
