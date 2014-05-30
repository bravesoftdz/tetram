package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 24/05/2014.
 */
public class AuteurLite extends AbstractDBEntity {
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
