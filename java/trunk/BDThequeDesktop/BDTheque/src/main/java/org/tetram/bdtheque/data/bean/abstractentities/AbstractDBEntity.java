package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.bean.DBEntity;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractDBEntity extends AbstractEntity implements DBEntity {

    private final ObjectProperty<UUID> id = new SimpleObjectProperty<>(this, "id", null);

    @Override
    public UUID getId() {
        return id.get();
    }

    @Override
    public void setId(UUID id) {
        this.id.set(id);
    }

    @Override
    public ObjectProperty<UUID> idProperty() {
        return id;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AbstractDBEntity)) return false;

        AbstractDBEntity that = (AbstractDBEntity) o;

        if (getId() != null ? !getId().equals(that.getId()) : that.getId() != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return getId() != null ? getId().hashCode() : 0;
    }

}
