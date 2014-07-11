package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.PersonneLite;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;

import java.net.URL;
import java.util.Comparator;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class BasePersonne extends AbstractDBEntity implements WebLinkedEntity {
    public final static Comparator<PersonneLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomPersonne(), o2.getNomPersonne());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomPersonne = new SimpleStringProperty(this, "nomPersonne", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    public String getNomPersonne() {
        return BeanUtils.trimOrNull(nomPersonne.get());
    }

    public void setNomPersonne(String nomPersonne) {
        this.nomPersonne.set(BeanUtils.trimOrNull(nomPersonne));
    }

    public StringProperty nomPersonneProperty() {
        return nomPersonne;
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomPersonne());
    }
}
