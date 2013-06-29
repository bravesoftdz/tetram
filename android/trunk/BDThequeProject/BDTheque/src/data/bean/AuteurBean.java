package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.AuteurLiteBean;
import org.tetram.bdtheque.data.factories.AuteurFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.AUTEURS_TABLENAME, primaryKey = DDLConstants.AUTEURS_ID, factoryClass = AuteurFactory.class)
public class AuteurBean extends AuteurLiteBean {

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

    public AuteurBean(Parcel in) {
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
