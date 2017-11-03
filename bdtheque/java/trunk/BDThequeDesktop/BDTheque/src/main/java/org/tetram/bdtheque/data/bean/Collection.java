/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * Collection.java
 * Last modified by Thierry, on 2014-10-30T18:32:35CET
 */

package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseCollection;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.data.dao.ScriptInfo;
import org.tetram.bdtheque.spring.SpringContext;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */

@ScriptInfo(typeData = 2, getParentIdMethod = "getIdEditeur")
public class Collection extends BaseCollection<Editeur> implements ScriptEntity {

    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    public void setIdEditeur(UUID idEditeur){
        EditeurDao editeurDao = SpringContext.CONTEXT.getBean(EditeurDao.class);
        setEditeur(editeurDao.get(idEditeur));
    }

}
