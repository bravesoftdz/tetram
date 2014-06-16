package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class ImageLite extends AbstractDBEntity {

    public static Comparator<ImageLite> DEFAULT_COMPARATOR = new Comparator<ImageLite>() {
        @Override
        public int compare(ImageLite o1, ImageLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = ValeurListe.DEFAULT_COMPARATOR.compare(o1.getCategorie(), o2.getCategorie());
            if (comparaison != 0) return comparaison;

            comparaison = BeanUtils.compare(o1.getPosition(), o2.getPosition());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };

    private String oldNom, newNom;
    private boolean oldStockee, newStockee;
    private ValeurListe categorie;
    private int position;

    public String getOldNom() {
        return BeanUtils.trimOrNull(oldNom);
    }

    public void setOldNom(String oldNom) {
        this.oldNom = BeanUtils.trimOrNull(oldNom);
    }

    public String getNewNom() {
        return BeanUtils.trimOrNull(newNom);
    }

    public void setNewNom(String newNom) {
        this.newNom = BeanUtils.trimOrNull(newNom);
    }

    public boolean isOldStockee() {
        return oldStockee;
    }

    public void setOldStockee(boolean oldStockee) {
        this.oldStockee = oldStockee;
    }

    public boolean isNewStockee() {
        return newStockee;
    }

    public void setNewStockee(boolean newStockee) {
        this.newStockee = newStockee;
    }

    public ValeurListe getCategorie() {
        return categorie;
    }

    public void setCategorie(ValeurListe categorie) {
        this.categorie = categorie;
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    @Override
    public String buildLabel() {
        return newNom;
    }
}
