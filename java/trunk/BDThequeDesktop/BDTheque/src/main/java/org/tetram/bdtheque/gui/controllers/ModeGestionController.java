package org.tetram.bdtheque.gui.controllers;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.value.ObservableNumberValue;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.gui.controllers.components.TreeViewMode;
import org.tetram.bdtheque.utils.FileLink;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Thierry on 14/07/2014.
 */
@Controller
// c'est la valeur par défaut, mais contrairement aux autres, il faut impérativement que ce controller soit un singleton
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
@FileLink("/org/tetram/bdtheque/gui/modeGestion.fxml")
public class ModeGestionController extends WindowController {
    @NonNls
    private static final String FILTRE_ACHAT = "Achat = 1";
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
    private TreeViewController entitiesController;

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
        buttonNodeHashMap.put(btParabd, TreeViewMode.PARAB_SERIE);
        buttonNodeHashMap.put(btAchatsParaBD, TreeViewMode.PARAB_SERIE);

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

        btRefresh.setOnAction(event -> entitiesController.refresh());

        entitiesController.setClickToShow(true);
        entitiesController.filtreProperty().bind(Bindings.createStringBinding(() -> {
            Toggle button = entitiesType.getSelectedToggle();
            if (button == btAchatsAlbums || button == btAchatsParaBD)
                return FILTRE_ACHAT;
            else
                return null;
        }, entitiesType.selectedToggleProperty()));
        entitiesType.selectedToggleProperty().addListener((observable, oldButton, newButton) -> {
            if (newButton == null) return;
            final TreeViewMode newMode = (TreeViewMode) newButton.getUserData();
            if (entitiesController.getMode().equals(newMode))
                entitiesController.refresh();
            else
                entitiesController.setMode(newMode);
        });

        entitiesType.selectToggle(btAlbums);
    }
}
