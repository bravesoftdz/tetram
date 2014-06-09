package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
public class PersonneLite extends AbstractDBEntity {
    public static Comparator<PersonneLite> DEFAULT_COMPARATOR = new Comparator<PersonneLite>() {
        @Override
        public int compare(PersonneLite o1, PersonneLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getNom(), o2.getNom());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private String nom;

    public String getNom() {
        return BeanUtils.trim(nom);
    }

    public void setNom(String nom) {
        this.nom = BeanUtils.trim(nom);
    }

    @Override
    public String buildLabel() {
        return StringUtils.formatTitre(getNom());
    }
}
