package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.I18nSupport;

/**
 * Created by Thierry on 24/05/2014.
 */
public enum MetierAuteur {

    SCENARISTE(0, I18nSupport.message("Scenariste")), DESSINATEUR(1, I18nSupport.message("Dessinateur")), COLORISTE(2, I18nSupport.message("Coloriste"));

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
