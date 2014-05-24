package org.tetram.bdtheque.data.bean.lite;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class CollectionLite extends DBEntityLite {
    private String nomCollection;
    private EditeurLite editeur;

    public String getNomCollection() {
        return nomCollection.trim();
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection = nomCollection.trim();
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
    }

    @Override
    public String toString() {
        return buildLabel(false);
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean simple) {
        String lb = StringUtils.formatTitre(nomCollection);
        if (!simple)
            lb = StringUtils.ajoutString(lb, StringUtils.formatTitre(editeur.getNomEditeur()), " ", "(", ")");
        return lb;
    }
}
