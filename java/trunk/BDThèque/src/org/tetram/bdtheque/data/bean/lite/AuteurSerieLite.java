package org.tetram.bdtheque.data.bean.lite;

import org.tetram.bdtheque.data.bean.MetierAuteur;

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

}
