/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * Univers.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseUnivers;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

@DaoScriptImpl.ScriptInfo(typeData = 15)
public class Univers extends BaseUnivers implements ScriptEntity {

    private final StringProperty description = new AutoTrimStringProperty(this, "description", null);
    private final ObjectProperty<UniversLite> universParent = new SimpleObjectProperty<>(this, "universParent", null);
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    public StringProperty descriptionProperty() {
        return description;
    }

    public UniversLite getUniversParent() {
        return universParent.get();
    }

    public void setUniversParent(UniversLite universParent) {
        this.universParent.set(universParent);
    }

    public ObjectProperty<UniversLite> universParentProperty() {
        return universParent;
    }

    public UUID getIdUniversParent() {
        return getUniversParent() == null ? null : getUniversParent().getId();
    }

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }
}
