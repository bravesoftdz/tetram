package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;
import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class BaseEditeur extends AbstractDBEntity implements WebLinkedEntity {

    public final static Comparator<BaseEditeur> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomEditeur(), o2.getNomEditeur());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomEditeur = new AutoTrimStringProperty(this, "nomEditeur", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    static {
        baseClass = BaseEditeur.class;
    }


    public StringProperty nomEditeurProperty() {
        return nomEditeur;
    }

    public String getNomEditeur() {
        return nomEditeur.get();
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur.set(nomEditeur);
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomEditeur());
    }

}
