package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;

/**
 * Created by Thierry on 01/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface EvaluatedEntity extends DBEntity {

    ObjectProperty<ValeurListe> notationProperty();

    ValeurListe getNotation();

    void setNotation(ValeurListe value);
}
