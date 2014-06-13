package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 25/05/2014.
 */
public class ValeurListe {

    public static Comparator<ValeurListe> DEFAULT_COMPARATOR = new Comparator<ValeurListe>() {
        @Override
        public int compare(ValeurListe o1, ValeurListe o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getPosition(), o2.getPosition());
            if (comparaison != 0) return comparaison;

            comparaison = BeanUtils.compare(o1.getValeur(), o2.getValeur());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private int valeur;
    private String texte;
    private int position;

    public int getValeur() {
        return valeur;
    }

    public void setValeur(int valeur) {
        this.valeur = valeur;
    }

    public String getTexte() {
        return BeanUtils.trimOrNull(texte);
    }

    public void setTexte(String texte) {
        this.texte = BeanUtils.trimOrNull(texte);
    }

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }
}
