package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
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

    private StringProperty nomCollection = new SimpleStringProperty(null);
    private ObjectProperty<Editeur> editeur = new SimpleObjectProperty<>(null);

    public String getNomCollection() {
        return BeanUtils.trimOrNull(nomCollection.get());
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.setValue(BeanUtils.trimOrNull(nomCollection));
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    public Editeur getEditeur() {
        return editeur.get();
    }

    public void setEditeur(Editeur editeur) {
        this.editeur.set(editeur);
    }

    public ObjectProperty<Editeur> editeurProperty() {
        return editeur;
    }

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }

}
