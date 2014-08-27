/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheCollectionController.java
 * Last modified by Tetram, on 2014-08-27T10:32:26CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.beans.binding.Bindings;
import javafx.beans.property.Property;
import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.dao.CollectionDao;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewSearchController;
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
    TreeViewSearchController tvEditeurController; // TODO: remplacer par la sélection d'un éditeur
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

        tvEditeurController.getTreeViewController().setMode(TreeViewMode.EDITEURS);
    }

    @SuppressWarnings("unchecked")
    @Override
    public void setIdEntity(UUID id) {
        collection = collectionDao.get(id);
        if (collection == null) collection = new Collection();

        tfNom.textProperty().bindBidirectional(collection.nomCollectionProperty());
        // TODO: ça ne fonctionne pas comme prévu, mais comme le composant doit être changé, ce n'est pas grave
        Bindings.bindBidirectional((Property<Editeur>) tvEditeurController.getTreeViewController().selectedEntityProperty(), collection.editeurProperty());
        taAssociations.textProperty().bindBidirectional(collection.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        collection.setNomCollection(label);
    }
}
