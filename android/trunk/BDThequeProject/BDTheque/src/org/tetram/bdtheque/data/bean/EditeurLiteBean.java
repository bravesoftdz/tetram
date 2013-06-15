package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

public class EditeurLiteBean extends CommonBean implements TreeNodeBean {
    private String nom;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Override
    public Float getTreeNodeRating() {
        return null;
    }

}
