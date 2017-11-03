package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.AuteurBeanAbstract;
import org.tetram.bdtheque.data.bean.enums.AuteurMetier;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.dao.AuteurSerieDao;
import org.tetram.bdtheque.data.factories.AuteurSerieFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.AUTEURS_SERIES_TABLENAME, primaryKey = DDLConstants.AUTEURS_SERIES_ID, factoryClass = AuteurSerieFactory.class)
@BeanDaoClass(AuteurSerieDao.class)
public class AuteurSerieBean extends AuteurBeanAbstract {

    @Field(fieldName = DDLConstants.SERIES_ID, nullable = false)
    private SerieLiteBean serie;
    @Field(fieldName = DDLConstants.AUTEURS_SERIES_METIER)
    private AuteurMetier metier;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<AuteurSerieBean> CREATOR = new Creator<AuteurSerieBean>() {
        @Override
        public AuteurSerieBean createFromParcel(Parcel source) {
            return new AuteurSerieBean(source);
        }

        @Override
        public AuteurSerieBean[] newArray(int size) {
            return new AuteurSerieBean[size];
        }
    };

    public AuteurSerieBean(Parcel in) {
        super(in);
    }

    public AuteurSerieBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.serie, flags);
        dest.writeSerializable(this.metier);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.serie = in.readParcelable(SerieLiteBean.class.getClassLoader());
        this.metier = (AuteurMetier) in.readSerializable();
    }

    public SerieLiteBean getSerie() {
        return this.serie;
    }

    public void setSerie(SerieLiteBean serie) {
        this.serie = serie;
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
