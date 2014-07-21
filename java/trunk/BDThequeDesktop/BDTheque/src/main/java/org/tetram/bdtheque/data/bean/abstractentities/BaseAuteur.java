package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.bean.PersonneLite;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;

import java.net.URL;

/**
 * Created by Thierry on 24/05/2014.
 */

public abstract class BaseAuteur extends AbstractDBEntity implements WebLinkedEntity {

    private final ObjectProperty<PersonneLite> personne = new SimpleObjectProperty<>(this, "personne", null);

    public ObjectProperty<PersonneLite> personneProperty() {
        return personne;
    }

    public PersonneLite getPersonne() {
        return personne.get();
    }

    public void setPersonne(PersonneLite personne) {
        this.personne.set(personne);
    }

    @Override
    public URL getSiteWeb() {
        return getPersonne() == null ? null : getPersonne().getSiteWeb();
    }

    @Override
    public void setSiteWeb(URL siteWeb) {
        if (getPersonne() != null) getPersonne().setSiteWeb(siteWeb);
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return getPersonne() == null ? null : getPersonne().siteWebProperty();
    }

    @SuppressWarnings("RedundantIfStatement")
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof BaseAuteur)) return false;
        if (!super.equals(o)) return false;

        BaseAuteur that = (BaseAuteur) o;

        if (getPersonne() != null ? !getPersonne().equals(that.getPersonne()) : that.getPersonne() != null)
            return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = super.hashCode();
        result = 31 * result + (getPersonne() != null ? getPersonne().hashCode() : 0);
        return result;
    }

    @Override
    public String buildLabel() {
        return getPersonne().buildLabel();
    }

    @Override
    public AbstractDBEntity lightRef() {
        BaseAuteur e = (BaseAuteur) super.lightRef();
        e.setPersonne((PersonneLite) this.getPersonne().lightRef());
        return e;
    }
}
