package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Collection extends AbstractDBEntity {
    private String nomCollection;
    private EditeurLite editeur;

    public String getNomCollection() {
        return BeanUtils.trim(nomCollection);
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection = BeanUtils.trim(nomCollection);
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
    }
}
