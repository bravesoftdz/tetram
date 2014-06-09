package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.util.Comparator;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurSerieLite extends AuteurLite {
    private UUID idSerie;
    private MetierAuteur metier;
    public static Comparator<AuteurSerieLite> DEFAULT_COMPARATOR = new Comparator<AuteurSerieLite>() {
        @Override
        public int compare(AuteurSerieLite o1, AuteurSerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.metier, o2.metier);
            if (comparaison != 0) return comparaison;

            comparaison = PersonneLite.DEFAULT_COMPARATOR.compare(o1.getPersonne(), o2.getPersonne());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };

    public MetierAuteur getMetier() {
        return metier;
    }

    public void setMetier(MetierAuteur metier) {
        this.metier = metier;
    }

    public UUID getIdSerie() {
        return idSerie;
    }

    public void setIdSerie(UUID idSerie) {
        this.idSerie = idSerie;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object other) {
        if (this == other) return true;
        if (!(other instanceof AuteurSerieLite)) return false;
        if (!super.equals(other)) return false;

        AuteurSerieLite that = (AuteurSerieLite) other;

        if (BeanUtils.compare(this.idSerie, that.idSerie) != 0) return false;
        if (BeanUtils.compare(this.metier, that.metier) != 0) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (idSerie != null ? idSerie.hashCode() : 0);
        result = 31 * result + (metier != null ? metier.hashCode() : 0);
        return result;
    }
}
