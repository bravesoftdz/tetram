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
import org.tetram.bdtheque.gui.controllers.components.ButtonsBarController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 21/07/2014.
 */
@Controller(value = "editGeneric")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheGeneric.fxml"),
})
public class FicheEditController<C extends WindowController & GestionController> extends WindowController {

    @FXML
    private ScrollPane detailPane;

    @FXML
    private ButtonsBarController buttonsController;

    private StringProperty label = new SimpleStringProperty(this, "label", null);
    private List<EventHandler<ActionEvent>> cancelHandlers = new ArrayList<>();
    private List<EventHandler<ActionEvent>> okHandlers = new ArrayList<>();

    private C childController;

    @FXML
    protected void initialize() {
        buttonsController.getBtCancel().setOnAction(event -> runHandlers(cancelHandlers, event));
        buttonsController.getBtOk().setOnAction(event -> runHandlers(okHandlers, event));
        label.bindBidirectional(buttonsController.getLbMessage().textProperty());
    }

    private synchronized void runHandlers(List<EventHandler<ActionEvent>> handlers, ActionEvent event) {
        handlers.forEach(handler -> handler.handle(event));
    }

    public void registerCancelHandler(EventHandler<ActionEvent> handler) {
        if (!cancelHandlers.contains(handler)) cancelHandlers.add(handler);
    }

    public void unregisterCancelHandler(EventHandler<ActionEvent> handler) {
        cancelHandlers.remove(handler);
    }

    public void registerOkHandler(EventHandler<ActionEvent> handler) {
        if (!okHandlers.contains(handler)) okHandlers.add(handler);
    }

    public void unregisterOkHandler(EventHandler<ActionEvent> handler) {
        okHandlers.remove(handler);
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
}
