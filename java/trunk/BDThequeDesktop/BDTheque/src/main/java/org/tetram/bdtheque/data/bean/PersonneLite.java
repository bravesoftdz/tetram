package org.tetram.bdtheque.data.bean;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class PersonneLite extends AbstractDBEntity {

    public final static Comparator<PersonneLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNom(), o2.getNom());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private StringProperty nom = new SimpleStringProperty(this, "nom", null);

    public String getNom() {
        return BeanUtils.trimOrNull(nom.get());
    }

    public void setNom(String nom) {
        this.nom.set(BeanUtils.trimOrNull(nom));
    }

    public StringProperty nomProperty() {
        return nom;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNom());
    }

}
