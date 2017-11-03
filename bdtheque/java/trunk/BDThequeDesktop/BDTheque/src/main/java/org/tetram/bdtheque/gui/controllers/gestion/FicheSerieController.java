/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * FicheSerieController.java
 * Last modified by Thierry, on 2014-10-31T18:10:57CET
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.fxml.FXML;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.GridPane;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.gui.components.EntityPicker;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.spring.utils.URLStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

// TODO: en cours

/**
 * Created by Thierry on 06/08/2014.
 */
@Controller(value = "editSerie")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheSerie.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheSerie-screenshot.jpg")
})
public class FicheSerieController extends GestionControllerImpl {

    @Autowired
    private SerieDao serieDao;

    @FXML
    private GridPane gpGrid;

    @FXML
    private TextField tfTitre;
    @FXML
    private Label lbSiteWeb;
    @FXML
    private TextField tfSiteWeb;
    @FXML
    private Label lbUnivers;
    private EntityPicker<UniversLite> epUnivers;
    @FXML
    private FlowPane fpUnivers;
    @FXML
    private TextArea taHistoire;
    @FXML
    private TextArea taNotes;
    @FXML
    private TextArea taAssociations;

    private Serie serie;

    @FXML
    void initialize() {
        epUnivers = new EntityPicker<>();
        GridPane.setColumnIndex(epUnivers, 1);
        GridPane.setRowIndex(epUnivers, 2);
        epUnivers.setMode(TreeViewMode.UNIVERS);
        // epUnivers.prefWidthProperty().bind(tfTitre.widthProperty());
        gpGrid.getChildren().add(gpGrid.getChildren().indexOf(lbUnivers) + 1, epUnivers);

        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Série/one"));

            controller.registerOkHandler(event -> {
                serieDao.save(serie);
            }, FicheEditController.HandlerPriority.HIGH);
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        serie = serieDao.get(id);
        if (serie == null) serie = new Serie();

        tfTitre.textProperty().bindBidirectional(serie.titreSerieProperty());

        // pourquoi la conversion d'URL introduit un délai quand la propriété doit être mise à jour est un mystère
        // alors que par un bête listener, cela ne pose aucun problème
        // tfSiteWeb.textProperty().bindBidirectional(univers.siteWebProperty(), new URLStringConverter());
        URLStringConverter urlConverter = new URLStringConverter();
        tfSiteWeb.setText(urlConverter.toString(serie.getSiteWeb()));
        tfSiteWeb.textProperty().addListener(o -> serie.setSiteWeb(urlConverter.fromString(tfSiteWeb.getText())));
        EntityWebHyperlink.addToLabeled(lbSiteWeb, serie.siteWebProperty(), ContentDisplay.GRAPHIC_ONLY, true);

        taHistoire.textProperty().bindBidirectional(serie.sujetProperty());
        taNotes.textProperty().bindBidirectional(serie.notesProperty());

        taAssociations.textProperty().bindBidirectional(serie.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        serie.setTitreSerie(label);
    }
}
