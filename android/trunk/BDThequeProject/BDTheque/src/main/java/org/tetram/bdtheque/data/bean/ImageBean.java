package org.tetram.bdtheque.data.bean;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.bean.lite.EditionLiteBean;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.IMAGES_TABLENAME, factoryClass = ImageFactory.class)
public class ImageBean extends CommonBean {
    @SuppressWarnings("FieldNameHidesFieldInSuperclass")
    public static final Creator<ImageBean> CREATOR = new Creator<ImageBean>() {
        @Override
        public ImageBean createFromParcel(Parcel source) {
            return new ImageBean(source);
        }

        @Override
        public ImageBean[] newArray(int size) {
            return new ImageBean[size];
        }
    };
    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.IMAGES_ID, primaryKey = true)
    private UUID id;
    @Field(fieldName = DDLConstants.ALBUMS_ID, nullable = true)
    private AlbumLiteBean album;
    @Field(fieldName = DDLConstants.EDITIONS_ID, nullable = true)
    private EditionLiteBean edition;
    @Field(fieldName = DDLConstants.IMAGES_ORDRE)
    private int ordre;
    @Field(fieldName = DDLConstants.IMAGES_STOCKAGE)
    private int stockageImage;
    //@Field(fieldName = DDLConstants.IMAGES_DATA)
    private Byte[] data;
    @Field(fieldName = DDLConstants.IMAGES_FICHIER)
    private String fichierImage;
    @Field(fieldName = DDLConstants.IMAGES_CATEGORIE)
    private ListeBean categorieImage;

    public ImageBean() {
        super();
    }

    public ImageBean(Parcel in) {
        super(in);
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(this.album, flags);
        dest.writeParcelable(this.edition, flags);
        dest.writeInt(this.ordre);
        dest.writeInt(this.stockageImage);
        //private Byte[] data;
        dest.writeString(this.fichierImage);
        dest.writeParcelable(this.categorieImage, flags);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.album = in.readParcelable(AlbumLiteBean.class.getClassLoader());
        this.edition = in.readParcelable(EditionLiteBean.class.getClassLoader());
        this.ordre = in.readInt();
        this.stockageImage = in.readInt();
        //private Byte[] data;
        this.fichierImage = in.readString();
        this.categorieImage = in.readParcelable(ListeBean.class.getClassLoader());
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public AlbumLiteBean getAlbum() {
        return this.album;
    }

    public void setAlbum(AlbumLiteBean album) {
        this.album = album;
    }

    public EditionLiteBean getEdition() {
        return this.edition;
    }

    public void setEdition(EditionLiteBean edition) {
        this.edition = edition;
    }

    public int getOrdre() {
        return this.ordre;
    }

    public void setOrdre(int ordre) {
        this.ordre = ordre;
    }

    public int getStockageImage() {
        return this.stockageImage;
    }

    public void setStockageImage(int stockageImage) {
        this.stockageImage = stockageImage;
    }

    public Byte[] getData() {
        return this.data;
    }

    public void setData(Byte[] data) {
        this.data = data;
    }

    public String getFichierImage() {
        return this.fichierImage;
    }

    public void setFichierImage(String fichierImage) {
        this.fichierImage = fichierImage;
    }

    public ListeBean getCategorieImage() {
        return this.categorieImage;
    }

    public void setCategorieImage(ListeBean categorieImage) {
        this.categorieImage = categorieImage;
    }
}
