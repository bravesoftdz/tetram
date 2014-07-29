/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheAuteurController.java
 * Last modified by Tetram, on 2014-07-29T11:02:06CEST
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
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.dao.PersonneDao;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.spring.utils.URLStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

/**
 * Created by Thierry on 18/07/2014.
 */
@Controller(value = "editAuteur")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheAuteur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheAuteur-screenshot.jpg")
})
public class FicheAuteurController extends GestionControllerImpl {

    @Autowired
    private PersonneDao personneDao;

    @FXML
    private TextField tfNom;
    @FXML
    private TextField tfSiteWeb;
    @FXML
    private Label lbSiteWeb;
    @FXML
    private TextArea taBiographie;
    @FXML
    private TextArea taAssociations;

    private Personne personne;

    @FXML
    void initialize() {
        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Auteur"));

            controller.registerOkHandler(event -> {
                personneDao.save(personne);
            }, FicheEditController.HandlerPriority.HIGH);
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        personne = personneDao.get(id);
        if (personne == null) personne = new Personne();

        tfNom.textProperty().bindBidirectional(personne.nomPersonneProperty());

        // pourquoi la conversion d'URL introduit un délai quand la propriété doit être mise à jour est un mystère
        // alors que par un bête listener, cela ne pose aucun problème
        // tfSiteWeb.textProperty().bindBidirectional(personne.siteWebProperty(), new URLStringConverter());
        URLStringConverter urlConverter = new URLStringConverter();
        tfSiteWeb.setText(urlConverter.toString(personne.getSiteWeb()));
        tfSiteWeb.textProperty().addListener(o -> personne.setSiteWeb(urlConverter.fromString(tfSiteWeb.getText())));
        EntityWebHyperlink.addToLabeled(lbSiteWeb, personne.siteWebProperty(), ContentDisplay.GRAPHIC_ONLY, true);

        taBiographie.textProperty().bindBidirectional(personne.biographieProperty());
        taAssociations.textProperty().bindBidirectional(personne.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        personne.setNomPersonne(label);
    }

}