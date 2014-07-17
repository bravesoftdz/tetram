package org.tetram.bdtheque.gui.controllers;

import org.jetbrains.annotations.NonNls;

/**
 * Created by Thierry on 17/07/2014.
 */
public enum ApplicationMode {
    CONSULTATION("modeConsultation.fxml"), GESTION("modeGestion.fxml");

    private final String resource;

    ApplicationMode(@NonNls String resource) {
        this.resource = resource;
    }

    public String getResource() {
        return resource;
    }
}
