/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * NotationResource.java
 * Last modified by Tetram, on 2014-07-29T11:02:06CEST
 */

package org.tetram.bdtheque.gui.utils;

import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.data.bean.ValeurListe;

/**
 * Created by Thierry on 01/07/2014.
 */
public enum NotationResource {
    PAS_NOTE(900, "notation_pas_note.png"),
    TRES_MAUVAIS(901, "notation_tres_mauvais.png"),
    MAUVAIS(902, "notation_mauvais.png"),
    MOYEN(903, "notation_moyen.png"),
    BIEN(904, "notation_bien.png"),
    TRES_BIEN(905, "notation_tres_bien.png");

    private final int value;
    private final String resource;

    NotationResource(int value, @NonNls String resource) {

        this.value = value;
        this.resource = resource;
    }

    public static NotationResource fromValue(ValeurListe value) {
        return fromValue(value.getValeur());
    }

    public static NotationResource fromValue(int value) {
        for (NotationResource resource : values()) {
            if (resource.value == value) return resource;
        }
        return null;
    }

    public int getValue() {
        return value;
    }

    public String getResource() {
        return resource;
    }
}
