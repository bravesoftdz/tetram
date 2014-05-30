package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class EditeurLite extends AbstractDBEntity {
    private String nomEditeur;

    public String getNomEditeur() {
        return nomEditeur.trim();
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = nomEditeur.trim();
    }

    @Override
    public String buildLabel() {
        return StringUtils.formatTitre(nomEditeur);
    }
}
