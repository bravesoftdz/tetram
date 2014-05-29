package org.tetram.bdtheque.data.bean.lite;

import org.tetram.bdtheque.data.bean.ValeurListe;

/**
 * Created by Thierry on 24/05/2014.
 */
public class ImageLite extends DBEntityLite {
    private String oldNom, newNom;
    private boolean oldStockee, newStockee;
    private ValeurListe categorie;

    public String getOldNom() {
        return oldNom;
    }

    public void setOldNom(String oldNom) {
        this.oldNom = oldNom;
    }

    public String getNewNom() {
        return newNom;
    }

    public void setNewNom(String newNom) {
        this.newNom = newNom;
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

    @Override
    public String buildLabel() {
        return newNom;
    }


}
