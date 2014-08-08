/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheEditeurController.java 
 * Last modified by Thierry, on 2014-08-06T10:53:56CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.fxml.FXML;
import javafx.scene.control.ContentDisplay;
import javafx.scene.control.Label;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.dao.EditeurDao;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.spring.utils.URLStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

/**
 * Created by Thierry on 06/08/2014.
 */
@Controller(value = "editEditeur")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheEditeur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheEditeur-screenshot.jpg")
})
public class FicheEditeurController extends GestionControllerImpl {

    @Autowired
    private EditeurDao editeurDao;

    @FXML
    private TextField tfNom;
    @FXML
    private TextField tfSiteWeb;
    @FXML
    private Label lbSiteWeb;
    @FXML
    private TextArea taAssociations;

    private Editeur editeur;

    @FXML
    void initialize() {
        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Editeur/one"));

            controller.registerOkHandler(event -> {
                editeurDao.save(editeur);
            }, FicheEditController.HandlerPriority.HIGH);
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        editeur = editeurDao.get(id);
        if (editeur == null) editeur = new Editeur();

        tfNom.textProperty().bindBidirectional(editeur.nomEditeurProperty());

        // pourquoi la conversion d'URL introduit un délai quand la propriété doit être mise à jour est un mystère
        // alors que par un bête listener, cela ne pose aucun problème
        // tfSiteWeb.textProperty().bindBidirectional(univers.siteWebProperty(), new URLStringConverter());
        URLStringConverter urlConverter = new URLStringConverter();
        tfSiteWeb.setText(urlConverter.toString(editeur.getSiteWeb()));
        tfSiteWeb.textProperty().addListener(o -> editeur.setSiteWeb(urlConverter.fromString(tfSiteWeb.getText())));
        EntityWebHyperlink.addToLabeled(lbSiteWeb, editeur.siteWebProperty(), ContentDisplay.GRAPHIC_ONLY, true);

        taAssociations.textProperty().bindBidirectional(editeur.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        editeur.setNomEditeur(label);
    }
}
