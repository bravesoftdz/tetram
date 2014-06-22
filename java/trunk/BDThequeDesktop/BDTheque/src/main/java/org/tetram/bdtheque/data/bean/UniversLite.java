package org.tetram.bdtheque.data.bean;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class UniversLite extends AbstractDBEntity {

    private StringProperty nomUnivers = new SimpleStringProperty(null);

    public String getNomUnivers() {
        return BeanUtils.trimOrNull(nomUnivers.get());
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers.set(BeanUtils.trimOrNull(nomUnivers));
    }

    public StringProperty nomUniversProperty() {
        return nomUnivers;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomUnivers());
    }

}
