package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 24/05/2014.
 */
public abstract class AuteurLite extends AbstractDBEntity {

    private PersonneLite personne;

    public PersonneLite getPersonne() {
        return personne;
    }

    public void setPersonne(PersonneLite personne) {
        this.personne = personne;
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof AuteurLite)) return false;
        if (!super.equals(o)) return false;

        AuteurLite that = (AuteurLite) o;

        if (personne != null ? !personne.equals(that.personne) : that.personne != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (personne != null ? personne.hashCode() : 0);
        return result;
    }

    @Override
    public String buildLabel() {
        return personne.buildLabel();
    }

}
