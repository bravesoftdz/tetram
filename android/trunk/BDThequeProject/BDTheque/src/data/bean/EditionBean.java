package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.factories.EditionFactory;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.EDITIONS_TABLENAME, primaryKey = DDLConstants.EDITIONS_ID, factoryClass = EditionFactory.class)
public class EditionBean extends CommonBean {

    private String isbn;
    private EditeurBean editeur;

    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<EditionBean> CREATOR = new Creator<EditionBean>() {
        @Override
        public EditionBean createFromParcel(Parcel source) {
            return new EditionBean(source);
        }

        @Override
        public EditionBean[] newArray(int size) {
            return new EditionBean[size];
        }
    };

    public EditionBean(Parcel in) {
        super(in);
    }

    public EditionBean() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.isbn);
        dest.writeParcelable(this.editeur, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.isbn = in.readString();
        this.editeur = in.readParcelable(EditeurBean.class.getClassLoader());
    }

    public String getISBN() {
        return this.isbn;
    }

    public void setISBN(String isbn) {
        this.isbn = isbn;
    }

    public EditeurBean getEditeur() {
        return this.editeur;
    }

    public void setEditeur(EditeurBean editeur) {
        this.editeur = editeur;
    }
}
