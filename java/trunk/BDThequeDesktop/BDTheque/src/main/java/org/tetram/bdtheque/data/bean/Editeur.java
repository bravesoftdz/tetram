package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;
import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */

// pour le moment pas de différence avec EditeurLite, mais Editeur pourrait à terme contenir la liste des Collections par exemple

@DaoScriptImpl.ScriptInfo(typeData = 3)
public class Editeur extends AbstractScriptEntity implements WebLinkedEntity {

    public final static Comparator<EditeurLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomEditeur(), o2.getNomEditeur());
        if (comparaison != 0) return comparaison;

        return 0;
    };

    private final StringProperty nomEditeur = new AutoTrimStringProperty(this, "nomEditeur", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

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
    public URL getSiteWeb() {
        return siteWeb.get();
    }

    @Override
    public void setSiteWeb(URL siteWeb) {
        this.siteWeb.set(siteWeb);
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return null;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomEditeur());
    }
}
