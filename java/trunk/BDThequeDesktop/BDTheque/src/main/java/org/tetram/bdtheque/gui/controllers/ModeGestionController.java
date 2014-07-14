package org.tetram.bdtheque.gui.controllers;

import javafx.beans.binding.Bindings;
import javafx.beans.value.ObservableNumberValue;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.ToggleButton;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.dao.RepertoireLiteDao;
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
    private ToggleButton btAchats;
    @FXML
    private ToggleButton btAlbums;

    @FXML
    public void initialize() {
        Map<ToggleButton, Class<? extends RepertoireLiteDao>> buttonNodeHashMap = new HashMap<>();
        buttonNodeHashMap.put(btAlbums, null);
        buttonNodeHashMap.put(btAchats, null);
        buttonNodeHashMap.put(btUnivers, null);
        buttonNodeHashMap.put(btSeries, null);
        buttonNodeHashMap.put(btAuteurs, null);
        buttonNodeHashMap.put(btEditeurs, null);
        buttonNodeHashMap.put(btCollections, null);
        buttonNodeHashMap.put(btGenres, null);
        buttonNodeHashMap.put(btParabd, null);

        ObservableNumberValue tabWidth = null;
        for (ToggleButton toggleButton : buttonNodeHashMap.keySet())
            tabWidth = tabWidth == null ? toggleButton.widthProperty() : Bindings.max(toggleButton.widthProperty(), tabWidth);
        for (ToggleButton toggleButton : buttonNodeHashMap.keySet()) {
            toggleButton.minWidthProperty().bind(tabWidth);
            //toggleButton.prefWidthProperty().bind(tabWidth);
        }

    }
}
