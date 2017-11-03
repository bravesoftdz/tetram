/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UniversAttachedEntity.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ListProperty;
import javafx.beans.property.ObjectProperty;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.List;

/**
 * Created by Thierry on 28/07/2014.
 */
public interface UniversAttachedEntity extends DBEntity {

    default void initUniversProperties() {
        final ListChangeListener<UniversLite> universListChangeListener = change -> universFullProperty().set(FXCollections.observableList(BeanUtils.checkAndBuildListUniversFull(getUniversFull(), getUnivers(), serieProperty().get())));
        serieProperty().addListener((observable, oldValue, newValue) -> {
            if (oldValue != null) oldValue.universProperty().removeListener(universListChangeListener);
            if (newValue != null) newValue.universProperty().addListener(universListChangeListener);
            universFullProperty().set(FXCollections.observableList(BeanUtils.checkAndBuildListUniversFull(getUniversFull(), getUnivers(), newValue)));
        });
        universProperty().addListener(universListChangeListener);
    }

    ObjectProperty<Serie> serieProperty();

    ListProperty<UniversLite> universProperty();

    ListProperty<UniversLite> universFullProperty();

    default List<UniversLite> getUniversFull() {
        return universFullProperty().get();
    }

    default List<UniversLite> getUnivers() {
        return universProperty().get();
    }

    default void setUnivers(List<UniversLite> univers) {
        this.universProperty().set(FXCollections.observableList(univers));
    }

    default boolean addUnivers(UniversLite universLite) {
        if (!universProperty().contains(universLite) && !universFullProperty().contains(universLite)) {
            universFullProperty().add(universLite);
            return universProperty().add(universLite);
        }
        return false;
    }

    default boolean removeUnivers(UniversLite universLite) {
        if (universProperty().remove(universLite)) {
            universFullProperty().remove(universLite);
            return true;
        } else
            return false;
    }

}
