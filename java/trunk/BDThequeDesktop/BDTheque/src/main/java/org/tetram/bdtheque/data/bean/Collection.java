package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@DaoScriptImpl.ScriptInfo(typeData = 2, getParentIdMethod = "getIdEditeur")
public class Collection extends AbstractScriptEntity {
    private String nomCollection;
    private EditeurLite editeur;

    public String getNomCollection() {
        return BeanUtils.trimOrNull(nomCollection);
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection = BeanUtils.trimOrNull(nomCollection);
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
    }

    @SuppressWarnings("UnusedDeclaration")
    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }
}
