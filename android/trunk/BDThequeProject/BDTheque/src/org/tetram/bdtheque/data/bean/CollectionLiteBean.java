package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

public class CollectionLiteBean extends CommonBean implements TreeNodeBean {

    private String nom;
    private EditeurLiteBean editeur;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getLabel(boolean simple) {
        String result = StringUtils.formatTitre(this.nom);
        if (!simple)
            return StringUtils.ajoutString(result, StringUtils.formatTitre(this.editeur.getNom()), " ", "(", ")");
        else
            return result;
    }

    public void setEditeur(EditeurLiteBean editeur) {
        this.editeur = editeur;
    }

    @Override
    public String getTreeNodeText() {
        return getLabel(true);
    }

    @Override
    public Float getTreeNodeRating() {
        return null;
    }
}
