package org.tetram.bdtheque.gui.controllers;

import org.jetbrains.annotations.NonNls;
import org.tetram.bdtheque.gui.utils.History;

/**
 * Created by Thierry on 17/07/2014.
 */
public enum ApplicationMode {
    CONSULTATION("modeConsultation.fxml", History.HistoryAction.MODE_CONSULTATION),
    GESTION("modeGestion.fxml", History.HistoryAction.MODE_GESTION);

    private final String resource;
    private History.HistoryAction historyAction;

    ApplicationMode(@NonNls String resource, History.HistoryAction historyAction) {
        this.resource = resource;
        this.historyAction = historyAction;
    }

    public String getResource() {
        return resource;
    }

    public History.HistoryAction getHistoryAction() {
        return historyAction;
    }
}
