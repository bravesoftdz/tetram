package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.Labeled;
import javafx.scene.control.ListView;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.FlowPane;
import javafx.util.converter.IntegerStringConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.dao.mappers.FileLink;
import org.tetram.bdtheque.data.dao.mappers.FileLinks;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.FlowItem;
import org.tetram.bdtheque.gui.utils.NotationResource;
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
    private ImageView appreciation;

    @FXML
    private Label titreSerie;

    @FXML
    private Label titreAlbum;

    @FXML
    private Label tome;

    @FXML
    private Label dateParution;

    @FXML
    private CheckBox integrale;

    @FXML
    private CheckBox horsSerie;

    @FXML
    private Label integraleTomes;

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
    private ListView<AlbumLite> lvSerie;

    @FXML
    public void initialize() {

    }

    @Override
    public void setIdEntity(UUID id) {
        // pas la peine de se prendre la tête à faire des bind, la fenêtre est recrée à chaque affichage

        Album album = albumDao.get(id);
        if (album == null)
            throw new EntityNotFoundException();

        final NotationResource notationResource = NotationResource.fromValue(album.getNotation());
        appreciation.setImage(new Image("/org/tetram/bdtheque/graphics/png/32x32/" + notationResource.getResource()));

        if (album.getSerie() != null) {
            titreSerie.setText(BeanUtils.formatTitre(album.getSerie().getTitreSerie()));
            album.getSerie().genresProperty().forEach(genre -> lvGenres.getChildren().add(FlowItem.create(genre.buildLabel())));
            lvSerie.itemsProperty().bind(album.getSerie().albumsProperty());
            album.getSerie().getAlbums().forEach(albumLite -> {
                if (album.getId().equals(albumLite.getId())) {
                    lvSerie.getSelectionModel().select(albumLite);
                    lvSerie.scrollTo(albumLite);
                }
            });
            lvSerie.setOnMouseClicked(event -> {
                if (event.getClickCount() == 2) {
                    AlbumLite entity = lvSerie.getSelectionModel().getSelectedItem();
                    if (entity != null)
                        modeConsultationController.showConsultationForm(entity);
                }
            });
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
