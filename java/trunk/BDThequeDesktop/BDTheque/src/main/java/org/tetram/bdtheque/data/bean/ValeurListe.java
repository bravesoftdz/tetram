package org.tetram.bdtheque.data.bean;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 25/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class ValeurListe {

    public final static Comparator<ValeurListe> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getPosition(), o2.getPosition());
        if (comparaison != 0) return comparaison;

        comparaison = BeanUtils.compare(o1.getValeur(), o2.getValeur());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final IntegerProperty valeur = new SimpleIntegerProperty(this, "valeur", 0);
    private final StringProperty texte = new SimpleStringProperty(this, "texte", null);
    private final IntegerProperty position = new SimpleIntegerProperty(this, "position", 0);

    public int getValeur() {
        return valeur.get();
    }

    public void setValeur(int valeur) {
        this.valeur.set(valeur);
    }

    public IntegerProperty valeurProperty() {
        return valeur;
    }

    public String getTexte() {
        return BeanUtils.trimOrNull(texte.get());
    }

    public void setTexte(String texte) {
        this.texte.set(BeanUtils.trimOrNull(texte));
    }

    public StringProperty texteProperty() {
        return texte;
    }

    public int getPosition() {
        return position.get();
    }

    public void setPosition(int position) {
        this.position.set(position);
    }

    public IntegerProperty positionProperty() {
        return position;
    }

}
