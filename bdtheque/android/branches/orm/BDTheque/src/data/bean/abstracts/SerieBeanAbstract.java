package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

@SuppressWarnings("UnusedDeclaration")
public abstract class SerieBeanAbstract extends CommonBean {
    @Field(fieldName = DDLConstants.SERIES_TITRE)
    protected String titre;
    @Field(fieldName = DDLConstants.SERIES_NOTATION)
    protected Notation notation;

    @Field(fieldName = DDLConstants.COLLECTIONS_ID, nullable = true)
    protected CollectionLiteBean collection;

    public SerieBeanAbstract(Parcel in) {
        super(in);
    }

    public SerieBeanAbstract() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.titre);
        dest.writeValue(this.notation);
        dest.writeParcelable(this.collection, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.titre = in.readString();
        this.notation = (Notation) in.readValue(Notation.class.getClassLoader());
        this.collection = in.readParcelable(CollectionLiteBean.class.getClassLoader());
    }

    public String getTitre() {
        return this.titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public Notation getNotation() {
        return this.notation;
    }

    public void setNotation(Notation notation) {
        this.notation = notation;
    }

    public CollectionLiteBean getCollection() {
        return this.collection;
    }

    public void setCollection(CollectionLiteBean collection) {
        this.collection = collection;
    }
}
