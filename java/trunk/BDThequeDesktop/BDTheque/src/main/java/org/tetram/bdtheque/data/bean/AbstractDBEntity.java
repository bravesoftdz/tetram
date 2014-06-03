package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class AbstractDBEntity extends AbstractEntity {
    private UUID id = StringUtils.GUID_NULL;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AbstractDBEntity)) return false;

        AbstractDBEntity that = (AbstractDBEntity) o;

        if (id != null ? !id.equals(that.id) : that.id != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }
}
