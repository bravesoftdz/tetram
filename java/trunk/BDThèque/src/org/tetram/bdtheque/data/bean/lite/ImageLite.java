package org.tetram.bdtheque.data.bean.lite;

/**
 * Created by Thierry on 24/05/2014.
 */
public class ImageLite extends DBEntityLite {
    private String oldNom, newNom;
    private boolean oldStockee, newStockee;
    private Integer categorie;
    private String sCategorie;

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

    public Integer getCategorie() {
        return categorie;
    }

    public void setCategorie(Integer categorie) {
        this.categorie = categorie;
    }

    public String getsCategorie() {
        return sCategorie;
    }

    public void setsCategorie(String sCategorie) {
        this.sCategorie = sCategorie;
    }

    @Override
    public String buildLabel() {
        return newNom;
    }


}
