package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
public class SerieLite extends AbstractDBEntity {
    public static Comparator<SerieLite> DEFAULT_COMPARATOR = new Comparator<SerieLite>() {
        @Override
        public int compare(SerieLite o1, SerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getTitreSerie(), o2.getTitreSerie());
            if (comparaison != 0) return comparaison;

            comparaison = EditeurLite.DEFAULT_COMPARATOR.compare(o1.getEditeur(), o2.getEditeur());
            if (comparaison != 0) return comparaison;

            comparaison = CollectionLite.DEFAULT_COMPARATOR.compare(o1.getCollection(), o2.getCollection());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private String titreSerie;
    private EditeurLite editeur;
    private CollectionLite collection;
    private Integer notation;

    public String getTitreSerie() {
        return BeanUtils.trim(titreSerie);
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie = BeanUtils.trim(titreSerie);
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
