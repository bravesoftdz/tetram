package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.FlowPane;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.ParaBDLite;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.dao.EvaluatedEntityDao;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.NotationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.gui.utils.FlowItem;
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
        @FileLink("/org/tetram/bdtheque/gui/consultation/fiche_serie-screenshot.jpg")
})
public class FicheSerieController extends WindowController implements ConsultationController {

    @FXML
    NotationController notationController;
    @Autowired
    private SerieDao serieDao;
    @Autowired
    private ModeConsultationController modeConsultationController;
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
    private ListView<AlbumLite> lvAlbums;
    @FXML
    private FlowPane lvUnivers;
    @FXML
    private TextFlow histoire;
    @FXML
    private TextFlow notes;
    @FXML
    private Hyperlink lbEditeur;
    @FXML
    private Hyperlink lbCollection;
    @FXML
    private CheckBox cbTerminee;
    @FXML
    private ListView<ParaBDLite> lvParabd;

    private ObjectProperty<Serie> serie = new SimpleObjectProperty<>();

    @FXML
    public void initialize() {
        notationController.entityProperty().bind(serie);
        notationController.setDao(((EvaluatedEntityDao) serieDao));
        final EventHandler<MouseEvent> onMouseClicked = event -> {
            if (event.getClickCount() == 2) {
                AbstractDBEntity entity = lvAlbums.getSelectionModel().getSelectedItem();
                if (entity != null)
                    modeConsultationController.showConsultationForm(entity);
            }
        };
        lvAlbums.setOnMouseClicked(onMouseClicked);
        lvParabd.setOnMouseClicked(onMouseClicked);
    }

    @Override
    public void setIdEntity(UUID id) {
        serie.set(serieDao.get(id));
        final Serie _serie = serie.get();
        if (_serie == null) throw new EntityNotFoundException();

        notationController.notationProperty().bindBidirectional(_serie.notationProperty());

        titreSerie.setText(BeanUtils.formatTitre(serie.get().getTitreSerie()));
        EntityWebHyperlink.addToLabeled(titreSerie, _serie.getSiteWeb());
        lbEditeur.setText(_serie.getEditeur() == null ? null : _serie.getEditeur().toString());
        EntityWebHyperlink.addToLabeled(lbEditeur, _serie.getEditeur().getSiteWeb());
        lbCollection.setText(_serie.getCollection() == null ? null : _serie.getCollection().buildLabel(true));
        lbEditeur.setOnAction(event -> {
            if (event.getTarget() != lbEditeur.getGraphic() && _serie.getEditeur() != null)
                modeConsultationController.showConsultationForm(_serie.getEditeur());
        });
        lbCollection.setOnAction(event -> {
            if (event.getTarget() != lbCollection.getGraphic() && _serie.getCollection() != null)
                modeConsultationController.showConsultationForm(_serie.getCollection());
        });
        cbTerminee.setSelected(serie.get().isTerminee());

        FlowItem.fillViewFromList(_serie.genresProperty(), lvGenres);
        final EventHandler<ActionEvent> openEntityEventHandler = event -> {
            final Labeled source = (Labeled) event.getSource();
            final AbstractDBEntity entity = (AbstractDBEntity) source.getUserData();
            modeConsultationController.showConsultationForm(entity);
        };
        FlowItem.fillViewFromList(_serie.universProperty(), lvUnivers, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.scenaristesProperty(), lvScenaristes, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.dessinateursProperty(), lvDessinateurs, openEntityEventHandler);
        FlowItem.fillViewFromList(_serie.coloristesProperty(), lvColoristes, openEntityEventHandler);

        histoire.getChildren().add(new Text(_serie.getSujet()));
        notes.getChildren().add(new Text(_serie.getNotes()));

        lvAlbums.itemsProperty().bind(_serie.albumsProperty());
        lvParabd.itemsProperty().bind(_serie.paraBDsProperty());
    }
}
