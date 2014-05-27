package org.tetram.bdtheque.data.bean.lite;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class DBEntityLite extends EntityLite {
    private UUID id;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }
}
