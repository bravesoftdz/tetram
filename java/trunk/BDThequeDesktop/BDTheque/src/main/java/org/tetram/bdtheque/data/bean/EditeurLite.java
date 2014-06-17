package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
public class EditeurLite extends AbstractDBEntity {
    public final static Comparator<EditeurLite> DEFAULT_COMPARATOR = new Comparator<EditeurLite>() {
        @Override
        public int compare(EditeurLite o1, EditeurLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getNomEditeur(), o2.getNomEditeur());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private String nomEditeur;

    public String getNomEditeur() {
        return BeanUtils.trimOrNull(nomEditeur);
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = BeanUtils.trimOrNull(nomEditeur);
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomEditeur());
    }
}
