package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.fxml.FXML;
import javafx.scene.control.CheckBox;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.util.converter.IntegerStringConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AuteurAlbumLite;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.dao.mappers.FileLink;
import org.tetram.bdtheque.data.dao.mappers.FileLinks;
import org.tetram.bdtheque.gui.controllers.WindowController;
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
    private ListView<UniversLite> lvUnivers;

    @FXML
    private ListView<GenreLite> lvGenres;

    @FXML
    private ListView<AuteurAlbumLite> lvScenaristes;

    @FXML
    private ListView<AuteurAlbumLite> lvDessinateurs;

    @FXML
    private ListView<AuteurAlbumLite> lvColoristes;

    @FXML
    public void initialize() {

    }

    @Override
    public void setIdEntity(UUID id) {
        // pas la peine de se prendre la tête à faire des bind, la fenêtre est recrée à chaque affichage

        Album album = albumDao.get(id);

        if (album.getSerie() != null) {
            titreSerie.setText(BeanUtils.formatTitre(album.getSerie().getTitreSerie()));
            lvGenres.itemsProperty().bind(album.getSerie().genresProperty());
        }
        titreAlbum.setText(BeanUtils.formatTitre(album.getTitreAlbum()));
        tome.textProperty().bindBidirectional(album.tomeProperty(), new IntegerStringConverter());

        String valueParution;
        if (album.getMoisParution() == null) {
            if (album.getAnneeParution() != null) {
                DateTimeFormatter format = DateTimeFormatter.ofPattern(I18nSupport.message("format.year"));
                valueParution = album.getAnneeParution().format(format);
            } else
                valueParution = null;
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

        lvUnivers.itemsProperty().bind(album.universFullProperty());
        lvScenaristes.itemsProperty().bind(album.scenaristesProperty());
        lvDessinateurs.itemsProperty().bind(album.dessinateursProperty());
        lvColoristes.itemsProperty().bind(album.coloristesProperty());
    }
}
