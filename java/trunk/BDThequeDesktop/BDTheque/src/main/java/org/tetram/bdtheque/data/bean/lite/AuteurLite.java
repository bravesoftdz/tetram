package org.tetram.bdtheque.data.bean.lite;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurLite extends DBEntityLite {
    private PersonneLite personne;

    public PersonneLite getPersonne() {
        return personne;
    }

    public void setPersonne(PersonneLite personne) {
        this.personne = personne;
    }

    @Override
    public String buildLabel() {
        return personne.buildLabel();
    }
}
