package org.tetram.bdtheque.data.bean.abstracts;

import android.os.Parcel;

import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class AlbumBeanAbstract extends CommonBean {

    @SuppressWarnings("InstanceVariableNamingConvention")
    @Field(fieldName = DDLConstants.ALBUMS_ID, primaryKey = true)
    protected UUID id;
    @Field(fieldName = DDLConstants.ALBUMS_TITRE)
    protected String titre;
    @Field(fieldName = DDLConstants.ALBUMS_TOME)
    protected Integer tome;
    @Field(fieldName = DDLConstants.ALBUMS_TOMEDEBUT)
    protected Integer tomeDebut;
    @Field(fieldName = DDLConstants.ALBUMS_TOMEFIN)
    protected Integer tomeFin;
    @Field(fieldName = DDLConstants.ALBUMS_HORSSERIE)
    protected Boolean horsSerie;
    @Field(fieldName = DDLConstants.ALBUMS_INTEGRALE)
    protected Boolean integrale;
    @Field(fieldName = DDLConstants.ALBUMS_MOISPARUTION)
    protected Integer moisParution;
    @Field(fieldName = DDLConstants.ALBUMS_ANNEEPARUTION)
    protected Integer anneeParution;
    @Field(fieldName = DDLConstants.ALBUMS_NOTATION)
    protected Notation notation = Notation.PAS_NOTE;
    @Field(fieldName = DDLConstants.ALBUMS_ACHAT)
    protected Boolean achat;
    // @Field(fieldName = DDLConstants.ALBUMS_COMPLET)
    protected Boolean complet;

    public AlbumBeanAbstract(Parcel in) {
        super(in);
    }

    public AlbumBeanAbstract() {
        super();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeString(this.titre);
        dest.writeValue(this.tome);
        dest.writeValue(this.tomeDebut);
        dest.writeValue(this.tomeFin);
        dest.writeValue(this.horsSerie);
        dest.writeValue(this.integrale);
        dest.writeValue(this.moisParution);
        dest.writeValue(this.anneeParution);
        dest.writeValue(this.notation);
        dest.writeValue(this.achat);
        dest.writeValue(this.complet);
    }

    @Override
    public void readFromParcel(Parcel in) {
        super.readFromParcel(in);
        this.titre = in.readString();
        this.tome = (Integer) in.readValue(Integer.class.getClassLoader());
        this.tomeDebut = (Integer) in.readValue(Integer.class.getClassLoader());
        this.tomeFin = (Integer) in.readValue(Integer.class.getClassLoader());
        this.horsSerie = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.integrale = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.moisParution = (Integer) in.readValue(Integer.class.getClassLoader());
        this.anneeParution = (Integer) in.readValue(Integer.class.getClassLoader());
        this.notation = (Notation) in.readValue(Notation.class.getClassLoader());
        this.achat = (Boolean) in.readValue(Boolean.class.getClassLoader());
        this.complet = (Boolean) in.readValue(Boolean.class.getClassLoader());
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public void setId(UUID id) {
        this.id = id;
    }

    public String getTitre() {
        return this.titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public Integer getTome() {
        return this.tome;
    }

    public void setTome(Integer tome) {
        this.tome = tome;
    }

    public Integer getTomeDebut() {
        return this.tomeDebut;
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut = tomeDebut;
    }

    public Integer getTomeFin() {
        return this.tomeFin;
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin = tomeFin;
    }

    public Boolean isHorsSerie() {
        return this.horsSerie;
    }

    public void setHorsSerie(Boolean horsSerie) {
        this.horsSerie = horsSerie;
    }

    public Boolean isIntegrale() {
        return this.integrale;
    }

    public void setIntegrale(Boolean integrale) {
        this.integrale = integrale;
    }

    public Integer getMoisParution() {
        return this.moisParution;
    }

    public void setMoisParution(Integer moisParution) {
        this.moisParution = moisParution;
    }

    public Integer getAnneeParution() {
        return this.anneeParution;
    }

    public void setAnneeParution(Integer anneeParution) {
        this.anneeParution = anneeParution;
    }

    public Notation getNotation() {
        return this.notation;
    }

    public void setNotation(Notation notation) {
        this.notation = notation;
    }

    public Boolean isAchat() {
        return this.achat;
    }

    public void setAchat(Boolean achat) {
        this.achat = achat;
    }

    public Boolean isComplet() {
        return this.complet;
    }

    public void setComplet(Boolean complet) {
        this.complet = complet;
    }
}
