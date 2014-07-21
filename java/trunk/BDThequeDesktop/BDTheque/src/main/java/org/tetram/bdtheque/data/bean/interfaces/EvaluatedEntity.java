package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ObjectProperty;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

/**
 * Created by Thierry on 01/07/2014.
 */

public interface EvaluatedEntity extends DBEntity {

    ObjectProperty<ValeurListe> notationProperty();

    default ValeurListe getNotation() {
        return notationProperty().get();
    }

    default void setNotation(ValeurListe value) {
        notationProperty().set(value == null || value.getValeur() == 0 ? SpringContext.CONTEXT.getBean(ValeurListeDao.class).getDefaultNotation() : value);
    }
}
