package org.tetram.bdtheque.data.bean;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface DBEntity {
    UUID getId();

    void setId(UUID id);
}
