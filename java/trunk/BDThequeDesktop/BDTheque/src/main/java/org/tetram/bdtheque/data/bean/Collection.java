package org.tetram.bdtheque.data.bean;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 2, getParentIdMethod = "getIdEditeur")
public class Collection extends AbstractScriptEntity {

    private StringProperty nomCollection = new SimpleStringProperty();
    private Editeur editeur;

    public String getNomCollection() {
        return BeanUtils.trimOrNull(nomCollection.getValueSafe());
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.setValue(BeanUtils.trimOrNull(nomCollection));
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    public Editeur getEditeur() {
        return editeur;
    }

    public void setEditeur(Editeur editeur) {
        this.editeur = editeur;
    }

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }

}
