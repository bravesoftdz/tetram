package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BaseEditeur;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

/**
 * Created by Thierry on 24/05/2014.
 */

// pour le moment pas de différence avec EditeurLite, mais Editeur pourrait à terme contenir la liste des Collections par exemple

@DaoScriptImpl.ScriptInfo(typeData = 3)
public class Editeur extends BaseEditeur implements ScriptEntity {

    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

}
