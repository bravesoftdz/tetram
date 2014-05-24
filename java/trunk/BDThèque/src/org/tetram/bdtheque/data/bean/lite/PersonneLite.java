package org.tetram.bdtheque.data.bean.lite;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class PersonneLite extends DBEntityLite {
    private String nom;

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    @Override
    public String buildLabel() {
        return StringUtils.formatTitre(nom);
    }
}
