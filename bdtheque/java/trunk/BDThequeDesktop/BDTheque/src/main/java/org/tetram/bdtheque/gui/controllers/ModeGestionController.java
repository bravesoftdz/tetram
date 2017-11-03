/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * ModeGestionController.java
 * Last modified by Thierry, on 2014-10-30T19:38:49CET
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.property.ReadOnlyListWrapper;
import javafx.beans.value.ObservableNumberValue;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseCollection;
import org.tetram.bdtheque.gui.controllers.gestion.FicheEditController;
import org.tetram.bdtheque.gui.controllers.gestion.GestionController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewSearchController;
import org.tetram.bdtheque.gui.utils.Forms;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.utils.FileLink;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Thierry on 14/07/2014.
 */
@Controller
// c'est la valeur par défaut, mais contrairement aux autres, il faut impérativement que ce controller soit un singleton
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
@FileLink("/org/tetram/bdtheque/gui/modeGestion.fxml")
public class ModeGestionController extends WindowController implements ModeController {
    @NonNls
    private static final String FILTRE_ACHAT = "Achat = 1";
    private final ReadOnlyListWrapper<Class<? extends AbstractEntity>> currentEntities = new ReadOnlyListWrapper<>(this, "currentEntity", FXCollections.observableArrayList());
    @FXML
    private ToolBar tbEntities;
    @FXML
    private Button btAcheter;
    @FXML
    private Button btSupprimer;
    @FXML
    private Button btModifier;
    @FXML
    private Button btNouveau;
    @FXML
    private Button btRefresh;
    @FXML
    private ToggleGroup entitiesType;
    @FXML
    private ToggleButton btAchatsParaBD;
    @FXML
    private ToggleButton btParabd;
    @FXML
    private ToggleButton btGenres;
    @FXML
    private ToggleButton btCollections;
    @FXML
    private ToggleButton btEditeurs;
    @FXML
    private ToggleButton btAuteurs;
    @FXML
    private ToggleButton btSeries;
    @FXML
    private ToggleButton btUnivers;
    @FXML
    private ToggleButton btAchatsAlbums;
    @FXML
    private ToggleButton btAlbums;
    @FXML
    private TreeViewSearchController entitiesController;
    @Autowired
    private History history;

    @SuppressWarnings("unchecked")
    @FXML
    public void initialize() {
        Map<ToggleButton, TreeViewMode> buttonNodeHashMap = new HashMap<>();
        buttonNodeHashMap.put(btAlbums, TreeViewMode.ALBUMS_SERIE);
        buttonNodeHashMap.put(btAchatsAlbums, TreeViewMode.ALBUMS_SERIE);
        buttonNodeHashMap.put(btUnivers, TreeViewMode.UNIVERS);
        buttonNodeHashMap.put(btSeries, TreeViewMode.SERIES);
        buttonNodeHashMap.put(btAuteurs, TreeViewMode.PERSONNES);
        buttonNodeHashMap.put(btEditeurs, TreeViewMode.EDITEURS);
        buttonNodeHashMap.put(btCollections, TreeViewMode.COLLECTIONS);
        buttonNodeHashMap.put(btGenres, TreeViewMode.GENRES);
        buttonNodeHashMap.put(btParabd, TreeViewMode.PARABD_SERIE);
        buttonNodeHashMap.put(btAchatsParaBD, TreeViewMode.PARABD_SERIE);

        ObservableNumberValue tabWidth = null;
        for (ToggleButton toggleButton : buttonNodeHashMap.keySet())
            tabWidth = tabWidth == null ? toggleButton.widthProperty() : Bindings.max(toggleButton.widthProperty(), tabWidth);

        final ObservableNumberValue finalTabWidth = tabWidth;
        Platform.runLater(() -> {
            for (ToggleButton toggleButton : buttonNodeHashMap.keySet())
                toggleButton.prefWidthProperty().bind(finalTabWidth);
        });

        for (ToggleButton toggleButton : buttonNodeHashMap.keySet()) {
            toggleButton.setUserData(buttonNodeHashMap.get(toggleButton));
        }

        getTreeViewController().setClickToShow(true);
        entitiesType.selectedToggleProperty().addListener((observable, oldButton, newButton) -> {
            List<Toggle> buttonsAchat = new ArrayList<>();
            buttonsAchat.add(btAchatsAlbums);
            buttonsAchat.add(btAchatsParaBD);

            if (newButton == null) return;
            final TreeViewMode newMode = (TreeViewMode) newButton.getUserData();

            if (!getTreeViewController().getMode().equals(newMode))
                getTreeViewController().setMode(TreeViewMode.NONE);

            if (buttonsAchat.contains(newButton))
                getTreeViewController().setFiltre(FILTRE_ACHAT);
            else
                getTreeViewController().setFiltre(null);

            if (!getTreeViewController().getMode().equals(newMode))
                getTreeViewController().setMode(newMode);
        });

        getTreeViewController().setOnGetLabel(
                (entity, defaultValue) -> {
                    if (entity instanceof BaseCollection)
                        return ((BaseCollection) entity).buildLabel(false);
                    else
                        return defaultValue;
                }
        );

        btModifier.disableProperty().bind(getTreeViewController().selectedEntityProperty().isNull());
        btSupprimer.disableProperty().bind(getTreeViewController().selectedEntityProperty().isNull());
        btAcheter.disableProperty().bind(
                getTreeViewController().selectedEntityProperty().isNull().or(
                        Bindings.and(
                                Bindings.createBooleanBinding(() -> !btAchatsAlbums.equals(entitiesType.getSelectedToggle()), entitiesType.selectedToggleProperty()),
                                Bindings.createBooleanBinding(() -> !btAchatsParaBD.equals(entitiesType.getSelectedToggle()), entitiesType.selectedToggleProperty())
                        )
                ));

        entitiesType.selectToggle(btAlbums);
    }

    public <T extends WindowController & GestionController> FicheEditController<T> showEditForm(AbstractDBEntity entity) {
        FicheEditController<T> controller = null;
        if (entity != null && !currentEntities.contains(entity.getEntityClass())) {
            controller = Forms.showEdit(entity);
            currentEntities.add(entity.getEntityClass());

            final EventHandler<ActionEvent> handler = event -> currentEntities.remove(entity.getEntityClass());
            controller.registerCancelHandler(handler, FicheEditController.HandlerPriority.LOW);
            controller.registerOkHandler(handler, FicheEditController.HandlerPriority.LOW);
        }
        return controller;
    }

    @FXML
    public void clickRefresh(ActionEvent actionEvent) {
        getTreeViewController().refreshTree();
    }

    @FXML
    public void clickNew(ActionEvent actionEvent) throws IllegalAccessException, InstantiationException {
        history.addWaiting(History.HistoryAction.GESTION_AJOUT, (AbstractDBEntity) getTreeViewController().getFinalEntityClass().newInstance(), getTreeViewController().getSearchText());
    }

    @FXML
    public void clickEdit(ActionEvent actionEvent) {
        history.addWaiting(History.HistoryAction.GESTION_MODIF, (AbstractDBEntity) getTreeViewController().getSelectedEntity());
    }

    @FXML
    public void clickDel(ActionEvent actionEvent) {
        history.addWaiting(History.HistoryAction.GESTION_SUPP, (AbstractDBEntity) getTreeViewController().getSelectedEntity());
    }

    @FXML
    public void clickAchat(ActionEvent actionEvent) {
        history.addWaiting(History.HistoryAction.GESTION_ACHAT, (AbstractDBEntity) getTreeViewController().getSelectedEntity());
    }

    private TreeViewController getTreeViewController() {
        return entitiesController.getTreeViewController();
    }
}
