package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;

import java.util.UUID;

/**
 * Created by Thierry on 01/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public interface EvaluatedEntity {
    UUID getId();

    ObjectProperty<ValeurListe> notationProperty();

    ValeurListe getNotation();

    void setNotation(ValeurListe value);
}
