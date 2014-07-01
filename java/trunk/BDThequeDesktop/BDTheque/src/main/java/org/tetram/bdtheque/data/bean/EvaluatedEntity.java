package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

/**
 * Created by Thierry on 01/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface EvaluatedEntity {
    ObjectProperty<ValeurListe> notationProperty();

    ValeurListe getNotation();

    void setNotation(ValeurListe value);
}
