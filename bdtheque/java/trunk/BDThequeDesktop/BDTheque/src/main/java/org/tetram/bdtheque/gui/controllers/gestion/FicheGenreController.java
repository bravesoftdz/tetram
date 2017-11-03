/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheGenreController.java 
 * Last modified by Thierry, on 2014-08-06T10:53:56CEST
 */

package org.tetram.bdtheque.gui.controllers.gestion;

import javafx.fxml.FXML;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Genre;
import org.tetram.bdtheque.data.dao.GenreDao;
import org.tetram.bdtheque.spring.utils.ListStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.UUID;

/**
 * Created by Thierry on 06/08/2014.
 */
@Controller(value = "editGenre")
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheGenre.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/gestion/ficheGenre-screenshot.jpg")
})
public class FicheGenreController extends GestionControllerImpl {

    @Autowired
    private GenreDao genreDao;

    @FXML
    private TextField tfNom;
    @FXML
    private TextArea taAssociations;

    private Genre genre;

    @FXML
    void initialize() {
        editControllerProperty().addListener(o -> {
            FicheEditController<?> controller = getEditController();
            controller.setLabel(I18nSupport.message("Genre/one"));

            controller.registerOkHandler(event -> {
                genreDao.save(genre);
            }, FicheEditController.HandlerPriority.HIGH);
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        genre = genreDao.get(id);
        if (genre == null) genre = new Genre();

        tfNom.textProperty().bindBidirectional(genre.nomGenreProperty());

        taAssociations.textProperty().bindBidirectional(genre.associationsProperty(), new ListStringConverter());
    }

    @Override
    public void setDefaultLabel(String label) {
        genre.setNomGenre(label);
    }
}
