package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class SerieLite extends AbstractDBEntity {
    private String titreSerie;
    private EditeurLite editeur;
    private CollectionLite collection;
    private Integer notation;

    public String getTitreSerie() {
        return titreSerie;
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie = titreSerie;
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
    }

    public CollectionLite getCollection() {
        return collection;
    }

    public void setCollection(CollectionLite collection) {
        this.collection = collection;
    }

    public Integer getNotation() {
        return notation;
    }

    public void setNotation(Integer notation) {
        this.notation = notation == 0 ? 900 : notation;
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean simple) {
        String lb = titreSerie;
        if (!simple)
            lb = StringUtils.formatTitre(lb);
        String s;
        s = StringUtils.ajoutString("", StringUtils.formatTitre(editeur.getNomEditeur()), " ");
        s = StringUtils.ajoutString(s, StringUtils.formatTitre(collection.getNomCollection()), " - ");
        return StringUtils.ajoutString(lb, s, " ", "(", ")");
    }
}
