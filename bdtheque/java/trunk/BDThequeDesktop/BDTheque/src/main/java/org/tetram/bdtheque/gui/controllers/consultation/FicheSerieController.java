/*
 * Copyright (c) 2015, tetram.org. All Rights Reserved.
 * FicheSerieController.java
 * Last modified by Thierry, on 2014-10-30T19:34:26CET
 */

package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;
import javafx.scene.layout.FlowPane;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.data.dao.EvaluatedEntityDao;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.includes.NotationController;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.gui.utils.FlowItem;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;

import java.util.UUID;

/**
 * Created by Thierry on 09/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheSerie.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheSerie-screenshot.jpg")
})
public class FicheSerieController extends WindowController implements ConsultationController {

    private final ObjectProperty<Serie> serie = new SimpleObjectProperty<>();
    @FXML
    NotationController notationController;
    @Autowired
    private SerieDao serieDao;
    @Autowired
    private History history;
    @FXML
    private Label titreSerie;
    @FXML
    private FlowPane lvGenres;
    @FXML
    private FlowPane lvScenaristes;
    @FXML
    private FlowPane lvDessinateurs;
    @FXML
    private FlowPane lvColoristes;
    @FXML
    private TreeViewController tvAlbumsController;
    @FXML
    private FlowPane lvUnivers;
    @FXML
    private TextFlow histoire;
    @FXML
    private TextFlow notes;
    @FXML
    private Label lbEditeur;
    @FXML
    private Label lbCollection;
    @FXML
    private CheckBox cbTerminee;
    @FXML
    private TreeViewController tvParabdController;

    @FXML
    public void initialize() {
        notationController.entityProperty().bind(serie);
        notationController.setDao(((EvaluatedEntityDao) serieDao));

        tvAlbumsController.setFinalEntityClass(BaseAlbum.class);
        tvAlbumsController.setOnIsLeaf((param, defaultValue) -> tvAlbumsController.getNodeLevel(param) == 1);
        tvAlbumsController.setOnGetLabel((param, defaultValue) -> ((BaseAlbum) param).buildLabel(false));

        tvParabdController.setFinalEntityClass(BaseParaBD.class);
        tvParabdController.setOnIsLeaf((param, defaultValue) -> tvParabdController.getNodeLevel(param) == 1);
        tvParabdController.setOnGetLabel((param, defaultValue) -> ((BaseParaBD) param).buildLabel(false));
    }

    @Override
    public void setIdEntity(UUID id) {
        serie.set(serieDao.get(id));
        final Serie _serie = serie.get();
        if (_serie == null) throw new EntityNotFoundException();

        notationController.notationProperty().bindBidirectional(_serie.notationProperty());

        titreSerie.setText(BeanUtils.formatTitre(serie.get().getTitreSerie()));
        EntityWebHyperlink.addToLabeled(titreSerie, _serie.siteWebProperty());
        lbEditeur.setText(_serie.getEditeur() == null ? null : _serie.getEditeur().toString());
        EntityWebHyperlink.addToLabeled(lbEditeur, _serie.getEditeur().siteWebProperty());
        lbCollection.setText(_serie.getCollection() == null ? null : _serie.getCollection().buildLabel(true));
        cbTerminee.setSelected(serie.get().isTerminee());

        FlowItem.fillViewFromList(_serie.getGenres(), lvGenres);
        final EventHandler<ActionEvent> openEntityEventHandler = event -> {
            final Labeled source = (Labeled) event.getSource();
            final AbstractDBEntity entity = (AbstractDBEntity) source.getUserData();
            history.addWaiting(History.HistoryAction.FICHE, entity);
        };
        FlowItem.fillViewFromList(_serie.getUnivers(), lvUnivers, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.getScenaristes(), lvScenaristes, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.getDessinateurs(), lvDessinateurs, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.getColoristes(), lvColoristes, openEntityEventHandler);

        histoire.getChildren().add(new Text(_serie.getSujet()));
        notes.getChildren().add(new Text(_serie.getNotes()));

        _serie.getAlbums();
        tvAlbumsController.setOnGetChildren(param -> _serie.albumsProperty());
        _serie.getParaBDs();
        tvParabdController.setOnGetChildren(param -> _serie.paraBDsProperty());
    }
}
