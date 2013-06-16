package org.tetram.bdtheque.data.bean;

import java.util.UUID;

public class CommonBean {
    @SuppressWarnings("InstanceVariableNamingConvention")
    private UUID id;

    public UUID getId() {
        return this.id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

}
