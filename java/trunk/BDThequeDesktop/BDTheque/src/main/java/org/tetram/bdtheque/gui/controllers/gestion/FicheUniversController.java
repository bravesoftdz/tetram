/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheUniversController.java
 * Last modified by Tetram, on 2014-07-29T11:02:07CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.UniversDao;
import org.tetram.bdtheque.gui.components.EntityPicker;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.spring.utils.URLStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 18/07/2014.
 */
@Controller(value = "editUnivers")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheUnivers.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheUnivers-screenshot.jpg")
})
public class FicheUniversController extends GestionControllerImpl {
    @Autowired
    private UniversDao universDao;

    @FXML
    private GridPane gpGrid;
    @FXML
    private TextField tfNom;
    @FXML
    private TextField tfSiteWeb;
    @FXML
    private Label lbSiteWeb;
    @FXML
    private TreeViewController tvAlbumsController;
    @FXML
    private TreeViewController tvParabdController;
    @FXML
    private TextArea taAssociations;

    private EntityPicker tfUniversParent;

    private Univers univers;

    @FXML
    void initialize() {
        tfUniversParent = new EntityPicker();
        GridPane.setColumnIndex(tfUniversParent, 1);
        GridPane.setColumnSpan(tfUniversParent, 2);
        GridPane.setRowIndex(tfUniversParent, 2);
        tfUniversParent.setMode(TreeViewMode.UNIVERS);
        tfUniversParent.prefWidthProperty().bind(tfNom.widthProperty());
        gpGrid.getChildren().add(tfUniversParent);

        DatePicker fTest = new DatePicker();
        GridPane.setColumnIndex(fTest, 1);
        GridPane.setColumnSpan(fTest, 2);
        GridPane.setRowIndex(fTest, 2);
//        gpGrid.getChildren().add(fTest);

        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Univers/one"));

            controller.registerOkHandler(event -> {
                universDao.save(univers);
            }, FicheEditController.HandlerPriority.HIGH);
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        univers = universDao.get(id);
        if (univers == null) univers = new Univers();

        tfNom.textProperty().bindBidirectional(univers.nomUniversProperty());

        // pourquoi la conversion d'URL introduit un délai quand la propriété doit être mise à jour est un mystère
        // alors que par un bête listener, cela ne pose aucun problème
        // tfSiteWeb.textProperty().bindBidirectional(univers.siteWebProperty(), new URLStringConverter());
        URLStringConverter urlConverter = new URLStringConverter();
        tfSiteWeb.setText(urlConverter.toString(univers.getSiteWeb()));
        tfSiteWeb.textProperty().addListener(o -> univers.setSiteWeb(urlConverter.fromString(tfSiteWeb.getText())));
        EntityWebHyperlink.addToLabeled(lbSiteWeb, univers.siteWebProperty(), ContentDisplay.GRAPHIC_ONLY, true);

        tfUniversParent.setParentValue(id);
        tfUniversParent.setValue(univers.getUniversParent());
        tfUniversParent.valueProperty().addListener(o -> univers.setUniversParent((UniversLite) tfUniversParent.getValue()));

        @SuppressWarnings("HardCodedStringLiteral") final String filtreBrancheUnivers = String.format("branche_univers containing '%s'", StringUtils.UUIDToGUIDString(univers.getId()));
        //tvAlbumsController.setClickToShow(false);
        tvAlbumsController.setMode(TreeViewMode.ALBUMS_SERIE);
        tvAlbumsController.setFiltre(filtreBrancheUnivers);
        //tvParabdController.setClickToShow(false);
        tvParabdController.setMode(TreeViewMode.PARABD_SERIE);
        tvParabdController.setFiltre(filtreBrancheUnivers);

        taAssociations.textProperty().bindBidirectional(univers.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        univers.setNomUnivers(label);
    }

}