/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * NotationController.java
 * Last modified by Tetram, on 2014-07-29T11:10:36CEST
 */

package org.tetram.bdtheque.gui.controllers.components;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.ContextMenu;
import javafx.scene.control.MenuItem;
import javafx.scene.control.Tooltip;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.input.MouseButton;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.dao.EvaluatedEntityDao;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.NotationResource;

/**
 * Created by Thierry on 08/07/2014.
 */

@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class NotationController extends WindowController {
    private final ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);
    private final ObjectProperty<EvaluatedEntity> entity = new SimpleObjectProperty<>(this, "entity", null);
    private final ObjectProperty<EvaluatedEntityDao> dao = new SimpleObjectProperty<>(this, "dao", null);
    @FXML
    public ImageView ivAppreciation;
    @Autowired
    private ValeurListeDao valeurListeDao;

    public NotationController() {
        notation.addListener((observable, oldValue, newValue) -> {
            if (newValue == null) return;
            final NotationResource notationResource = NotationResource.fromValue(newValue);
            ivAppreciation.setImage(new Image("/org/tetram/bdtheque/graphics/png/32x32/" + notationResource.getResource()));
            Tooltip.install(ivAppreciation, new Tooltip(newValue.getTexte()));
        });
    }

    @SuppressWarnings("unchecked")
    @FXML
    public void initialize() {
        final ContextMenu contextMenu = new ContextMenu();
        for (ValeurListe valeurListe : valeurListeDao.getListValeurListe(CategorieValeurListe.NOTATION)) {
            final NotationResource notationResource = NotationResource.fromValue(valeurListe);
            final MenuItem menuItem = new MenuItem(valeurListe.getTexte(), new ImageView(new Image("/org/tetram/bdtheque/graphics/png/32x32/" + notationResource.getResource())));
            menuItem.setOnAction(event -> {
                getDao().changeNotation(getEntity(), valeurListe);
                notation.set(valeurListe);
            });
            contextMenu.getItems().add(menuItem);
        }

        ivAppreciation.setOnMouseClicked(event -> {
            if (event.getButton() == MouseButton.SECONDARY)
                contextMenu.show(ivAppreciation, event.getScreenX(), event.getScreenY());
        });
    }

    public ValeurListe getNotation() {
        return notation.get();
    }

    public void setNotation(ValeurListe notation) {
        this.notation.set(notation);
    }

    public ObjectProperty<ValeurListe> notationProperty() {
        return notation;
    }

    public ObjectProperty<EvaluatedEntity> entityProperty() {
        return entity;
    }

    public EvaluatedEntity getEntity() {
        return entity.get();
    }

    public void setEntity(EvaluatedEntity entity) {
        this.entity.set(entity);
    }

    public EvaluatedEntityDao getDao() {
        return dao.get();
    }

    public void setDao(EvaluatedEntityDao dao) {
        this.dao.set(dao);
    }

    public ObjectProperty<? extends EvaluatedEntityDao> daoProperty() {
        return dao;
    }
}
