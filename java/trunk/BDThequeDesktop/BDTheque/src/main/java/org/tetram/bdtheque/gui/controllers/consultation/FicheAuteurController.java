/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * FicheAuteurController.java
 * Last modified by Tetram, on 2014-08-27T10:24:16CEST
 */

package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.Label;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.data.bean.abstractentities.BaseSerie;
import org.tetram.bdtheque.data.dao.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.dao.PersonneDao;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 09/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAuteur.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAuteur-screenshot.jpg")
})
public class FicheAuteurController extends WindowController implements ConsultationController {

    private final ObjectProperty<Personne> personne = new SimpleObjectProperty<>();
    @Autowired
    private PersonneDao personneDao;
    @Autowired
    private AlbumLiteSerieDao albumDao;
    @FXML
    private TreeViewController tvSeriesController;
    @FXML
    private Label lbNom;
    @FXML
    private TextFlow tfBiographie;

    @Override
    public void setIdEntity(UUID id) {
        personne.set(personneDao.get(id));
        final Personne _personne = personne.get();
        if (_personne == null) throw new EntityNotFoundException();

        lbNom.setText(BeanUtils.formatTitre(_personne.getNomPersonne()));
        EntityWebHyperlink.addToLabeled(lbNom, _personne.siteWebProperty());
        tfBiographie.getChildren().add(new Text(_personne.getBiographie()));

        tvSeriesController.setFinalEntityClass(BaseAlbum.class);
        tvSeriesController.setOnIsLeaf(treeItem -> tvSeriesController.getNodeLevel(treeItem) == 2);
        tvSeriesController.setOnRenderCell(cell -> {
            if (cell.getItem() instanceof BaseSerie)
                cell.getStyleClass().add(TreeViewController.NODE_BOLD_CSS);
        });
        tvSeriesController.setOnGetLabel(entity -> {
            if (entity instanceof BaseAlbum)
                return ((BaseAlbum) entity).buildLabel(false);
            else if (((AbstractDBEntity) entity).getId() == null)
                return albumDao.getUnknownLabel();
            else
                return entity.buildLabel();
        });
        tvSeriesController.setOnGetChildren(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            switch (tvSeriesController.getTreeView().getTreeItemLevel(treeItem)) {
                case 0:
                    return _personne.getSeries();
                case 1:
                    Serie serie = (Serie) entity;
                    List<AbstractEntity> list = new ArrayList<>();
                    list.addAll(serie.getAlbums());
                    list.addAll(serie.getParaBDs());
                    return list;
            }
            return null;
        });
    }
}
