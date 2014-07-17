package org.tetram.bdtheque.gui.controllers;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.value.ObservableNumberValue;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.ToggleButton;
import javafx.scene.control.ToggleGroup;
import javafx.scene.control.ToolBar;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.utils.FileLink;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 14/07/2014.
 */
@Controller
// c'est la valeur par défaut, mais contrairement aux autres, il faut impérativement que ce controller soit un singleton
@Scope(ConfigurableBeanFactory.SCOPE_SINGLETON)
@FileLink("/org/tetram/bdtheque/gui/modeGestion.fxml")
public class ModeGestionController extends WindowController {
    @FXML
    private ToggleGroup entitiesType;
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
    private TreeViewController entitiesController;

    private ObjectProperty<RepertoireLiteDao> dao = new SimpleObjectProperty<>(this, "dao", null);

    @SuppressWarnings("unchecked")
    @FXML
    public void initialize() {
        Map<ToggleButton, Class<? extends RepertoireLiteDao>> buttonNodeHashMap = new HashMap<>();
        buttonNodeHashMap.put(btAlbums, AlbumLiteDao.class);
        buttonNodeHashMap.put(btAchats, null);
        buttonNodeHashMap.put(btUnivers, UniversLiteDao.class);
        buttonNodeHashMap.put(btSeries, SerieLiteDao.class);
        buttonNodeHashMap.put(btAuteurs, PersonneLiteDao.class);
        buttonNodeHashMap.put(btEditeurs, EditeurLiteDao.class);
        buttonNodeHashMap.put(btCollections, CollectionLiteDao.class);
        buttonNodeHashMap.put(btGenres, GenreLiteDao.class);
        buttonNodeHashMap.put(btParabd, ParaBDLiteDao.class);

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

        entitiesController.setClickToShow(true);
        entitiesController.setOnGetLabel(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null)
                return null;
            else
                return entity.buildLabel();
        });
        entitiesController.onGetChildrenProperty().setValue(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null) {
                // c'est la racine
                return dao.get().getInitiales(null);
            } else if (entity instanceof InitialeEntity) {
                // c'est le niveau 1
                return dao.get().getListEntitiesByInitiale((InitialeEntity<UUID>) entity, null);
            }
            return null;
        });


        dao.addListener(observable -> entitiesController.refresh());
        entitiesType.selectedToggleProperty().addListener((observable, oldButton, newButton) -> {
            if (newButton == null) return;
            Class<RepertoireLiteDao> daoClass = (Class<RepertoireLiteDao>) newButton.getUserData();
            dao.set(SpringContext.CONTEXT.getBean(daoClass));
        });

        btAlbums.fire();
    }
}
