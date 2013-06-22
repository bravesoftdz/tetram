package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.SerieFactory;
import org.tetram.bdtheque.utils.BeanFactoryClass;

@SuppressWarnings("UnusedDeclaration")
@BeanFactoryClass(SerieFactory.class)
public class SerieBean extends SerieLiteBean {

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

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
    }
}
