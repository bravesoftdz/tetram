package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAuteur;
import org.tetram.bdtheque.data.bean.abstractentities.BasePersonne;

import java.util.Comparator;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class AuteurSerieLite extends BaseAuteur {

    public static Comparator<AuteurSerieLite> DEFAULT_COMPARATOR = new Comparator<AuteurSerieLite>() {
        @Override
        public int compare(AuteurSerieLite o1, AuteurSerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getMetier(), o2.getMetier());
            if (comparaison != 0) return comparaison;

            comparaison = BasePersonne.DEFAULT_COMPARATOR.compare(o1.getPersonne(), o2.getPersonne());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private final ObjectProperty<UUID> idSerie = new SimpleObjectProperty<>(this, "idSerie", null);
    private final ObjectProperty<MetierAuteur> metier = new SimpleObjectProperty<>(this, "metier", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return AuteurSerieLite.class;
    }

    public UUID getIdSerie() {
        return idSerie.get();
    }

    public void setIdSerie(UUID idSerie) {
        this.idSerie.set(idSerie);
    }

    public ObjectProperty<UUID> idSerieProperty() {
        return idSerie;
    }

    public MetierAuteur getMetier() {
        return metier.get();
    }

    public void setMetier(MetierAuteur metier) {
        this.metier.set(metier);
    }

    public ObjectProperty<MetierAuteur> metierProperty() {
        return metier;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object other) {
        if (this == other) return true;
        if (!(other instanceof AuteurSerieLite)) return false;
        if (!super.equals(other)) return false;

        AuteurSerieLite that = (AuteurSerieLite) other;

        if (BeanUtils.compare(this.getIdSerie(), that.getIdSerie()) != 0) return false;
        if (BeanUtils.compare(this.getMetier(), that.getMetier()) != 0) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (getIdSerie() != null ? getIdSerie().hashCode() : 0);
        result = 31 * result + (getMetier() != null ? getMetier().hashCode() : 0);
        return result;
    }

    @Override
    public AbstractDBEntity lightRef() {
        AuteurSerieLite e = (AuteurSerieLite) super.lightRef();
        e.setIdSerie(this.getIdSerie());
        e.setMetier(this.getMetier());
        return e;
    }
}
