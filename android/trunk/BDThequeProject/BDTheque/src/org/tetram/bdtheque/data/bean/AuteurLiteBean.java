package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.utils.StringUtils;

public class AuteurLiteBean extends CommonBean implements TreeNodeBean {

    private String nom;

    @Override
    public String getTreeNodeText() {
        return StringUtils.formatTitre(this.nom);
    }

    @Nullable
    @Override
    public Float getTreeNodeRating() {
        return null;
    }

    @SuppressWarnings("UnusedDeclaration")
    public String getNom() {
        return this.nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }
}
