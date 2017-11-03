/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheEditController.java
 * Last modified by Tetram, on 2014-07-29T11:10:36CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.ScrollPane;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.includes.ButtonsBarController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Thierry on 21/07/2014.
 */
@Controller(value = "editGeneric")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheGeneric.fxml"),
})
public class FicheEditController<C extends WindowController & GestionController> extends WindowController {

    private final StringProperty label = new SimpleStringProperty(this, "label", null);
    private final Map<HandlerPriority, List<EventHandler<ActionEvent>>> cancelHandlers = new HashMap<>();
    private final Map<HandlerPriority, List<EventHandler<ActionEvent>>> okHandlers = new HashMap<>();
    @FXML
    private ScrollPane detailPane;
    @FXML
    private ButtonsBarController buttonsController;
    private C childController;

    @FXML
    protected void initialize() {
        buttonsController.getBtCancel().setOnAction(event -> runHandlers(cancelHandlers, event));
        buttonsController.getBtOk().setOnAction(event -> runHandlers(okHandlers, event));
        label.bindBidirectional(buttonsController.getLbMessage().textProperty());
    }

    private synchronized void runHandlers(Map<HandlerPriority, List<EventHandler<ActionEvent>>> handlers, ActionEvent event) {
        for (HandlerPriority handlerPriority : HandlerPriority.values()) {
            final List<EventHandler<ActionEvent>> handlerList = handlers.get(handlerPriority);
            if (handlerList != null)
                handlerList.forEach(handler -> handler.handle(event));
        }
    }

    private void registerHandler(EventHandler<ActionEvent> handler, HandlerPriority priority, Map<HandlerPriority, List<EventHandler<ActionEvent>>> handlers) {
        handlers.putIfAbsent(priority, new ArrayList<>());
        final List<EventHandler<ActionEvent>> handlerList = handlers.get(priority);
        if (!handlerList.contains(handler)) handlerList.add(handler);
    }

    public void registerCancelHandler(EventHandler<ActionEvent> handler, HandlerPriority priority) {
        registerHandler(handler, priority, cancelHandlers);
    }

    public void registerOkHandler(EventHandler<ActionEvent> handler, HandlerPriority priority) {
        registerHandler(handler, priority, okHandlers);
    }

    private void unregisterHandler(EventHandler<ActionEvent> handler, Map<HandlerPriority, List<EventHandler<ActionEvent>>> handlers) {
        for (HandlerPriority priority : HandlerPriority.values()) {
            final List<EventHandler<ActionEvent>> handlerList = handlers.get(priority);
            if (handlerList != null) handlerList.remove(handler);
        }
    }

    public void unregisterCancelHandler(EventHandler<ActionEvent> handler) {
        unregisterHandler(handler, cancelHandlers);
    }

    public void unregisterOkHandler(EventHandler<ActionEvent> handler) {
        unregisterHandler(handler, okHandlers);
    }

    public ScrollPane getDetailPane() {
        return detailPane;
    }

    public C getChildController() {
        return childController;
    }

    public void setChildController(C childController) {
        this.childController = childController;
    }

    public String getLabel() {
        return label.get();
    }

    public void setLabel(String label) {
        this.label.set(label);
    }

    public StringProperty labelProperty() {
        return label;
    }

    public enum HandlerPriority {
        HIGH, UNDEFINED, LOW
    }
}
