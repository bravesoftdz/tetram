package org.tetram.bdtheque.data.bean.lite;

import android.os.Parcel;
import android.os.Parcelable;

import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.abstracts.EditeurBeanAbstract;
import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.data.dao.lite.EditeurLiteDao;
import org.tetram.bdtheque.data.factories.lite.EditeurLiteFactory;
import org.tetram.bdtheque.data.orm.annotations.BeanDaoClass;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITEURS_TABLENAME, factoryClass = EditeurLiteFactory.class)
@BeanDaoClass(EditeurLiteDao.class)
public class EditeurLiteBean extends EditeurBeanAbstract implements TreeNodeBean {

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Parcelable.Creator<EditeurLiteBean> CREATOR = new Parcelable.Creator<EditeurLiteBean>() {
        @Override
        public EditeurLiteBean createFromParcel(Parcel source) {
            return new EditeurLiteBean(source);
        }

        @Override
        public EditeurLiteBean[] newArray(int size) {
            return new EditeurLiteBean[size];
        }
    };

    public EditeurLiteBean(Parcel in) {
        super(in);
    }

    public EditeurLiteBean() {
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

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Override
    public Notation getTreeNodeRating() {
        return Notation.PAS_NOTE;
    }

}
