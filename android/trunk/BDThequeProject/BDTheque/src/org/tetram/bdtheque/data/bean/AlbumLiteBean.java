package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
public class AlbumLiteBean extends CommonBean implements TreeNodeBean {

    private String titre;
    private Integer tome;
    private Integer tomeDebut, tomeFin;
    private Boolean horsSerie;
    private Boolean integrale;
    private Integer moisParution, anneeParution;
    private Integer notation;
    private SerieLiteBean serie;
    private Boolean achat, complet;

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

    public Integer getNotation() {
        return this.notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation;
    }

    public SerieLiteBean getSerie() {
        return this.serie;
    }

    public void setSerie(SerieLiteBean serie) {
        this.serie = serie;
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

    public String getLabel(boolean simple, boolean avecSerie) {
        return StringUtils.formatTitreAlbum(
                simple,
                avecSerie,
                this.titre,
                (this.serie != null) ? this.serie.getTitre() : null,
                this.tome,
                this.tomeDebut,
                this.tomeFin,
                this.integrale,
                this.horsSerie);
    }

    @Override
    public String getTreeNodeText() {
        return getLabel(false, true);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return (this.notation == null) ? null : Float.valueOf(this.notation);
    }
}
