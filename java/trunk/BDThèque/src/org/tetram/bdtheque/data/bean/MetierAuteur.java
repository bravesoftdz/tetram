package org.tetram.bdtheque.data.bean;

/**
 * Created by Thierry on 24/05/2014.
 */
public enum MetierAuteur {
    SCENARISTE(0, "Scénariste"), DESSINATEUR(1, "Dessinateur"), COLORISTE(2, "Coloriste");

    private int value;
    private String label;

    public int getValue() {
        return value;
    }

    public String getLabel() {
        return label;
    }

    MetierAuteur(int value, String label) {
        this.value = value;
        this.label = label;
    }
}
