/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * FicheCollectionController.java
 * Last modified by Thierry, on 2014-10-31T18:19:45CET
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.abstractentities.BaseEditeur;
import org.tetram.bdtheque.data.dao.CollectionDao;
import org.tetram.bdtheque.gui.components.EntityPicker;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

/**
 * Created by Thierry on 06/08/2014.
 */
@Controller(value = "editCollection")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheCollection.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheCollection-screenshot.jpg")
})
public class FicheCollectionController extends GestionControllerImpl {

    @Autowired
    CollectionDao collectionDao;
    @FXML
    EntityPicker<BaseEditeur> epEditeur;
    @FXML
    private TextField tfNom;
    @FXML
    private TextArea taAssociations;

    private Collection collection;

    @FXML
    void initialize() {
        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Genre/one"));

            controller.registerOkHandler(event -> {
                collectionDao.save(collection);
            }, FicheEditController.HandlerPriority.HIGH);
        });

        epEditeur.setMode(TreeViewMode.EDITEURS);
        epEditeur.prefWidthProperty().bind(tfNom.widthProperty());
    }

    @SuppressWarnings("unchecked")
    @Override
    public void setIdEntity(UUID id) {
        collection = collectionDao.get(id);
        if (collection == null) collection = new Collection();

        tfNom.textProperty().bindBidirectional(collection.nomCollectionProperty());
        epEditeur.setValue(collection.getEditeur());
        epEditeur.valueProperty().addListener(o -> collection.setIdEditeur(epEditeur.getValue().getId()));
        taAssociations.textProperty().bindBidirectional(collection.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        collection.setNomCollection(label);
    }
}
