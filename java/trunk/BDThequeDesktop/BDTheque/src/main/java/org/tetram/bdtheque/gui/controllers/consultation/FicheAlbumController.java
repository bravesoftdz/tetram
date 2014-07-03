package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.util.converter.IntegerStringConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.dao.mappers.FileLink;
import org.tetram.bdtheque.data.dao.mappers.FileLinks;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.FlowItem;
import org.tetram.bdtheque.utils.I18nSupport;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Created by Thierry on 02/07/2014.
 */
@Controller
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAlbum.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/fiche_album-screenshot.jpg")
})
public class FicheAlbumController extends WindowController implements ConsultationController {

    @Autowired
    private AlbumDao albumDao;

    @Autowired
    private ModeConsultationController modeConsultationController;

    @FXML
    private CheckBox horsSerie;

    @FXML
    private Label tome;

    @FXML
    private CheckBox integrale;

    @FXML
    private Label integraleTomes;

    @FXML
    private Label titreSerie;

    @FXML
    private Label titreAlbum;

    @FXML
    private Label dateParution;

    @FXML
    private FlowPane lvUnivers;

    @FXML
    private FlowPane lvGenres;

    @FXML
    private FlowPane lvScenaristes;

    @FXML
    private FlowPane lvDessinateurs;

    @FXML
    private FlowPane lvColoristes;

    @FXML
    public void initialize() {

    }

    @Override
    public void setIdEntity(UUID id) {
        lvUnivers.parentProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                lvUnivers.prefWidthProperty().bind(((Pane) newValue).widthProperty());
        });
        lvGenres.parentProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                lvGenres.prefWidthProperty().bind(((Pane) newValue).widthProperty());
        });
        lvScenaristes.parentProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                lvScenaristes.prefWidthProperty().bind(((Pane) newValue).widthProperty());
            }
        });
        lvDessinateurs.parentProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                lvDessinateurs.prefWidthProperty().bind(((Pane) newValue).widthProperty());
            }
        });
        lvColoristes.parentProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null) {
                lvColoristes.prefWidthProperty().bind(((Pane) newValue).widthProperty());
            }
        });

        // pas la peine de se prendre la tête à faire des bind, la fenêtre est recrée à chaque affichage

        Album album = albumDao.get(id);
        if (album == null)
            throw new EntityNotFoundException();

        if (album.getSerie() != null) {
            titreSerie.setText(BeanUtils.formatTitre(album.getSerie().getTitreSerie()));
            album.getSerie().genresProperty().forEach(genre -> lvGenres.getChildren().add(FlowItem.create(genre.buildLabel())));
        }
        titreAlbum.setText(BeanUtils.formatTitre(album.getTitreAlbum()));
        tome.textProperty().bindBidirectional(album.tomeProperty(), new IntegerStringConverter());

        String valueParution;
        if (album.getMoisParution() == null) {
            if (album.getAnneeParution() != null) {
                DateTimeFormatter format = DateTimeFormatter.ofPattern(I18nSupport.message("format.year"));
                valueParution = album.getAnneeParution().format(format);
            } else {
                valueParution = null;
            }
        } else {
            YearMonth parution = album.getAnneeParution().atMonth(album.getMoisParution());
            DateTimeFormatter format = DateTimeFormatter.ofPattern(I18nSupport.message("format.month-year"));
            valueParution = parution.format(format);
        }
        dateParution.setText(valueParution);

        integrale.setSelected(album.isIntegrale());
        integraleTomes.setVisible(album.getTomeDebut() != null && album.getTomeFin() != null);
        integraleTomes.setText(I18nSupport.message("integrale.de-a", album.getTomeDebut(), album.getTomeFin()));
        horsSerie.setSelected(album.isHorsSerie());

        final EventHandler<ActionEvent> openEntityEventHandler = event -> {
            final Labeled source = (Labeled) event.getSource();
            final AbstractDBEntity entity = (AbstractDBEntity) source.getUserData();
            modeConsultationController.showConsultationForm(entity);
        };
        album.universFullProperty().forEach(univers -> lvUnivers.getChildren().add(FlowItem.create(univers.buildLabel(), openEntityEventHandler, univers)));
        album.scenaristesProperty().forEach(auteur -> lvScenaristes.getChildren().add(FlowItem.create(auteur.buildLabel(), openEntityEventHandler, auteur)));
        album.dessinateursProperty().forEach(auteur -> lvDessinateurs.getChildren().add(FlowItem.create(auteur.buildLabel(), openEntityEventHandler, auteur)));
        album.coloristesProperty().forEach(auteur -> lvColoristes.getChildren().add(FlowItem.create(auteur.buildLabel(), openEntityEventHandler, auteur)));
    }
}
