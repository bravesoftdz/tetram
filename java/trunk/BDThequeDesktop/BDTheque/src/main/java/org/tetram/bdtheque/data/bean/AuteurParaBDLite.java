package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurParaBDLite extends AuteurLite {
    private UUID idParaBD;

    public UUID getIdParaBD() {
        return idParaBD;
    }

    public void setIdParaBD(UUID idParaBD) {
        this.idParaBD = idParaBD;
    }
}
