package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.springframework.util.ClassUtils;
import org.tetram.bdtheque.data.bean.interfaces.DBEntity;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractDBEntity extends AbstractEntity implements DBEntity {

    static protected Class<? extends AbstractDBEntity> baseClass = AbstractDBEntity.class;
    private final ObjectProperty<UUID> id = new SimpleObjectProperty<>(this, "id", null);

    @Override
    public ObjectProperty<UUID> idProperty() {
        return id;
    }

    @SuppressWarnings({"RedundantIfStatement", "AccessStaticViaInstance"})
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AbstractDBEntity)) return false;

        AbstractDBEntity that = (AbstractDBEntity) o;

        if (baseClass != that.baseClass) return false;
        if (getId() != null ? !getId().equals(that.getId()) : that.getId() != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return getId() != null ? getId().hashCode() : 0;
    }

    @SuppressWarnings("unchecked")
    public AbstractDBEntity lightRef() {
        AbstractDBEntity e = null;
        try {
            final Class<? extends AbstractDBEntity> userClass = (Class<? extends AbstractDBEntity>) ClassUtils.getUserClass(this);
            e = userClass.newInstance();
            e.setId(this.getId());
        } catch (InstantiationException | IllegalAccessException e1) {
            e1.printStackTrace();
        }
        return e;
    }
}
