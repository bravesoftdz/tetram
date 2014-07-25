package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

/**
 * Created by Thierry on 25/07/2014.
 */
public class InitialeWithEntity<I, E extends AbstractDBEntity> {
    private ObjectProperty<InitialeEntity<I>> initiale = new SimpleObjectProperty<>(this, "initiale", null);
    private ObjectProperty<E> entity = new SimpleObjectProperty<>(this, "entity", null);

    public InitialeEntity<I> getInitiale() {
        return initiale.get();
    }

    public void setInitiale(InitialeEntity<I> initiale) {
        this.initiale.set(initiale);
    }

    public ObjectProperty<InitialeEntity<I>> initialeProperty() {
        return initiale;
    }

    public E getEntity() {
        return entity.get();
    }

    public void setEntity(E entity) {
        this.entity.set(entity);
    }

    public ObjectProperty<E> entityProperty() {
        return entity;
    }
}
