package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

public class AuteurLiteBean extends CommonBean implements TreeNodeBean {

    private String nom;

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Override
    public Float getTreeNodeRating() {
        return null;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
