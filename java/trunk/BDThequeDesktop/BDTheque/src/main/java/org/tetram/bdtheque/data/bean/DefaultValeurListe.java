package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 28/05/2014.
 */
public class DefaultValeurListe {

    private ValeurListe valeur;
    private CategorieValeurListe categorie = CategorieValeurListe.NOT_USED;

    public ValeurListe getValeur() {
        return valeur;
    }

    public void setValeur(ValeurListe valeur) {
        this.valeur = valeur;
    }

    public CategorieValeurListe getCategorie() {
        return categorie;
    }

    public void setCategorie(CategorieValeurListe categorie) {
        this.categorie = categorie;
    }

}
