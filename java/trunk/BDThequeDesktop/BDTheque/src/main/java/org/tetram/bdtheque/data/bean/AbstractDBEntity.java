package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class AbstractDBEntity extends AbstractEntity {
    private UUID id;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }
}
