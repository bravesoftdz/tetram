package org.tetram.bdtheque.data.bean.enums;

import org.jetbrains.annotations.Nullable;

@SuppressWarnings("UnusedDeclaration")
public enum AuteurMetier {
    SCENARISTE(0), DESSINATEUR(1), COLORISTE(2);

    private final int value;

    AuteurMetier(int value) {
        this.value = value;
    }

    public int getValue() {
        return this.value;
    }

    @Nullable
    public static AuteurMetier fromValue(int value) {
        switch (value) {
            case 0:
                return SCENARISTE;
            case 1:
                return DESSINATEUR;
            case 2:
                return COLORISTE;
            default:
                return null;
        }
    }
}
