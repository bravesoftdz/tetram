package org.tetram.bdtheque.data.bean.enums;

import org.jetbrains.annotations.Nullable;

@SuppressWarnings("UnusedDeclaration")
public enum ListeCategorie {
    ETAT(1),
    RELIURE(2),
    TYPE_EDITION(3),
    ORIENTATION(4),
    FORMAT_EDITION(5),
    CATEGORIE_IMAGE(6),
    CATEGORIE_PARABD(7),
    SENS_LECTURE(8);

    private final int value;

    ListeCategorie(int value) {
        this.value = value;
    }

    @Nullable
    public static ListeCategorie fromValue(int value) {
        for (final ListeCategorie type : values())
            if (type.value == value) return type;
        return null;
    }

    public int getValue() {
        return this.value;
    }
}
