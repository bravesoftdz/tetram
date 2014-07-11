package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.interfaces.WebLinkedEntity;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.net.URL;

/**
 * Created by Thierry on 11/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class BaseUnivers extends AbstractDBEntity implements WebLinkedEntity {
    private final StringProperty nomUnivers = new AutoTrimStringProperty(this, "nomUnivers", null);
    private final ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    public String getNomUnivers() {
        return nomUnivers.get();
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers.set(nomUnivers);
    }

    public StringProperty nomUniversProperty() {
        return nomUnivers;
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomUnivers());
    }
}
