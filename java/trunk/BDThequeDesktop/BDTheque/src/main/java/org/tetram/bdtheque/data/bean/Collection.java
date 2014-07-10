package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractCollection;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 2, getParentIdMethod = "getIdEditeur")
public class Collection extends AbstractCollection {

    private final ObjectProperty<Editeur> editeur = new SimpleObjectProperty<>(this, "editeur", null);

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

    @Override
    public String buildLabel(boolean simple) {
        String lb = BeanUtils.formatTitre(getNomCollection());
        if (!simple && getEditeur() != null)
            lb = StringUtils.ajoutString(lb, getEditeur().buildLabel(), " ", "(", ")");
        return lb;
    }


}
