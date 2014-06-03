package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurSerieLite extends AuteurLite {
    private UUID idSerie;
    private MetierAuteur metier;

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
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuteurSerieLite)) return false;
        if (!super.equals(o)) return false;

        AuteurSerieLite that = (AuteurSerieLite) o;

        if (idSerie != null ? !idSerie.equals(that.idSerie) : that.idSerie != null) return false;
        if (metier != that.metier) return false;

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
