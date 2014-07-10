package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractCollection;
import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class CollectionLite extends AbstractCollection {

    private final ObjectProperty<EditeurLite> editeur = new SimpleObjectProperty<>(this, "editeur", null);

    public EditeurLite getEditeur() {
        return editeur.get();
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur.set(editeur);
    }

    public ObjectProperty<EditeurLite> editeurProperty() {
        return editeur;
    }

    @Override
    public String buildLabel(boolean simple) {
        String lb = BeanUtils.formatTitre(getNomCollection());
        if (!simple && getEditeur() != null)
            lb = StringUtils.ajoutString(lb, BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ", "(", ")");
        return lb;
    }

}
