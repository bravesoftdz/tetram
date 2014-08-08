/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * MetierAuteur.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.I18nSupport;

/**
 * Created by Thierry on 24/05/2014.
 */
public enum MetierAuteur {

    SCENARISTE(0, I18nSupport.message("Scenariste/one")), DESSINATEUR(1, I18nSupport.message("Dessinateur/one")), COLORISTE(2, I18nSupport.message("Coloriste/one"));

    private final int value;
    private final String label;

    MetierAuteur(int value, String label) {
        this.value = value;
        this.label = label;
    }

    public int getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

}
