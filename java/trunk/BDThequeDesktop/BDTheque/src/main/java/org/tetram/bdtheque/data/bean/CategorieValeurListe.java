package org.tetram.bdtheque.data.bean;

import org.jetbrains.annotations.NotNull;

/**
 * Created by Thierry on 28/05/2014.
 */
public enum CategorieValeurListe {

    NOT_USED(0), ETAT(1), RELIURE(2), TYPE_EDITION(3), ORIENTATION(4), FORMAT_EDITION(5), TYPE_COUVERTURE(6),
    TYPE_PARABD(7), SENS_LECTURE(8), NOTATION(9), TYPE_PHOTO(10);

    private final int valeur;

    CategorieValeurListe(int valeur) {
        this.valeur = valeur;
    }

    @NotNull
    public CategorieValeurListe fromValue(int valeur) {
        for (CategorieValeurListe c : CategorieValeurListe.values())
            if (c.valeur == valeur) return c;
        return NOT_USED;
    }

    public int getValeur() {
        return valeur;
    }

}
