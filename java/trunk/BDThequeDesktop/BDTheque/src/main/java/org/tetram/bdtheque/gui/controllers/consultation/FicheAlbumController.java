package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.beans.binding.Bindings;
import javafx.beans.property.ListProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.geometry.Pos;
import javafx.scene.Cursor;
import javafx.scene.control.*;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.VBox;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import javafx.util.converter.IntegerStringConverter;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.dao.CouvertureLiteDao;
import org.tetram.bdtheque.data.dao.EvaluatedEntityDao;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.components.NotationController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.gui.utils.FlowItem;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.ISBNUtils;

import java.io.ByteArrayInputStream;
import java.text.MessageFormat;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Created by Thierry on 02/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAlbum.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheAlbum-screenshot.jpg")
})
public class FicheAlbumController extends WindowController implements ConsultationController {

    @NonNls
    private static final String CSS_FLOW_B0RDER = "flow-border";

    @Autowired
    private History history;
    @Autowired
    private AlbumDao albumDao;
    @Autowired
    private CouvertureLiteDao couvertureDao;
    @Autowired
    private UserPreferences userPreferences;

    @FXML
    private NotationController notationController;
    @FXML
    private Hyperlink titreSerie;
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
    private TextFlow histoire;
    @FXML
    private TextFlow notes;

    @FXML
    private Pagination diaporama;

    @FXML
    private ListView<Edition> lvEditions;

    @FXML
    private VBox detailEdition;
    @FXML
    private Label lbIsbn;
    @FXML
    private Label lbEditeur;
    @FXML
    private Label lbCollection;
    @FXML
    private Label lbCote;
    @FXML
    private Label lbDateAchat;
    @FXML
    private Label lbPrix;
    @FXML
    private Label lbAnneeEdition;
    @FXML
    private CheckBox cbOffert;
    @FXML
    private CheckBox cbStock;
    @FXML
    private Label lbPages;
    @FXML
    private CheckBox cbDedicace;
    @FXML
    private CheckBox cbVO;
    @FXML
    private CheckBox cbCouleur;
    @FXML
    private Label lbReliure;
    @FXML
    private Label lbOrientation;
    @FXML
    private Label lbSensLecture;
    @FXML
    private Label lbFormat;
    @FXML
    private Label lbEtat;
    @FXML
    private Label lbNumeroPerso;
    @FXML
    private Label lbAchete;
    @FXML
    private TextFlow tfNotesEdition;

    private ObjectProperty<Album> album = new SimpleObjectProperty<>();
    private ObjectProperty<Serie> serie = new SimpleObjectProperty<>();
    private ListProperty<Edition> editions = new SimpleListProperty<>();
    private ObjectProperty<Edition> currentEdition = new SimpleObjectProperty<>();
    private ListProperty<CouvertureLite> images = new SimpleListProperty<>();
    private Image[] cacheImages = null;

    @FXML
    public void initialize() {
        album.addListener((observable, oldAlbum, album) -> {
            serie.unbind();

            if (album == null) return;
            notationController.notationProperty().bindBidirectional(album.notationProperty());
            serie.bind(album.serieProperty());
        });

        serie.addListener((observable, oldSerie, serie) -> {
            if (serie == null) return;
            titreSerie.setText(BeanUtils.formatTitre(serie.getTitreSerie()));
            EntityWebHyperlink.addToLabeled(titreSerie, serie.siteWebProperty());

            FlowItem.fillViewFromList(serie.genresProperty(), lvGenres);
            lvSerie.itemsProperty().bind(serie.albumsProperty());
            if (album.get() != null) // ça devrait pas arriver mais on sait jamais
                serie.getAlbums().forEach(albumLite -> {
                    if (album.get().getId().equals(albumLite.getId())) {
                        lvSerie.getSelectionModel().select(albumLite);
                        lvSerie.scrollTo(albumLite);
                    }
                });
            lvSerie.setOnMouseClicked(event -> {
                if (event.getClickCount() == 2) {
                    AlbumLite entity = lvSerie.getSelectionModel().getSelectedItem();
                    if (entity != null)
                        history.addWaiting(History.HistoryAction.FICHE, entity);
                }
            });
        });

        titreSerie.setOnAction(event -> {
            if (event.getTarget() != titreSerie.getGraphic() && serie.get() != null)
                history.addWaiting(History.HistoryAction.FICHE, serie.get());
        });

        notationController.entityProperty().bind(album);
        notationController.setDao(((EvaluatedEntityDao) albumDao));

        lvSerie.setCellFactory(param -> {
            ListCell<AlbumLite> cell = new ListCell<>();
            cell.underlineProperty().bind(Bindings.equal(cell.itemProperty(), album));
            cell.textProperty().bind(Bindings.createStringBinding(() -> cell.itemProperty().get() == null ? null : cell.itemProperty().get().buildLabel(false), cell.itemProperty()));
            return cell;
        });
        lvEditions.setCellFactory(param -> {
            ListCell<Edition> cell = new ListCell<>();
            cell.underlineProperty().bind(Bindings.equal(cell.itemProperty(), currentEdition));
            cell.textProperty().bind(Bindings.createStringBinding(() -> cell.itemProperty().get() == null ? null : cell.itemProperty().get().buildLabel(), cell.itemProperty()));
            return cell;
        });

        detailEdition.visibleProperty().bind(Bindings.isNotEmpty(editions));
        lvEditions.visibleProperty().bind(Bindings.greaterThan(editions.sizeProperty(), 1));
        lvEditions.itemsProperty().bind(editions);
        lvEditions.setOnMouseClicked((event) -> {
            if (event.getClickCount() == 2)
                currentEdition.set(lvEditions.getSelectionModel().getSelectedItem());
        });

        diaporama.pageCountProperty().bind(images.sizeProperty());
        diaporama.pageCountProperty().addListener((observable, oldValue, newValue) -> diaporama.setCurrentPageIndex(0));
        diaporama.visibleProperty().bind(Bindings.greaterThan(diaporama.pageCountProperty(), 0));
        diaporama.setPageFactory(this::createImagePage);

        currentEdition.addListener((observable) -> {
            Edition edition = currentEdition.get();
            if (edition == null) return;

            lvEditions.getSelectionModel().select(edition);

            lbIsbn.setText(edition.getIsbn() == null ? null : ISBNUtils.formatISBN(edition.getIsbn()));
            lbEditeur.setText(edition.getEditeur() == null ? null : edition.getEditeur().toString());
            EntityWebHyperlink.addToLabeled(lbEditeur, edition.getEditeur().siteWebProperty());
            lbCollection.setText(edition.getCollection() == null ? null : edition.getCollection().buildLabel(true));
            lbCote.setText(edition.getAnneeCote() == null ? null : MessageFormat.format("{0} ({0})", I18nSupport.getCurrencyFormatter().format(edition.getPrixCote()), edition.getAnneeCote().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.year")))));
            lbAchete.setText(edition.isOffert() ? "Offert le :" : "Acheté le :");
            lbDateAchat.setText(edition.getDateAchat() == null ? null : edition.getDateAchat().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.date"))));
            lbPrix.setText(edition.getPrix() == null ? null : I18nSupport.getCurrencyFormatter().format(edition.getPrix()));

            lbAnneeEdition.setText(edition.getAnneeEdition().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.year"))));
            cbOffert.setSelected(edition.isOffert());
            cbStock.setSelected(edition.isStock());
            lbReliure.setText(edition.getReliure().getTexte());
            lbOrientation.setText(edition.getOrientation().getTexte());
            lbSensLecture.setText(edition.getSensLecture().getTexte());
            lbFormat.setText(edition.getFormatEdition().getTexte());
            lbEtat.setText(edition.getEtat().getTexte());
            lbNumeroPerso.setText(edition.getNumeroPerso());
            lbPages.textProperty().bindBidirectional(edition.nombreDePagesProperty(), new IntegerStringConverter());
            cbDedicace.setSelected(edition.isDedicace());
            cbVO.setSelected(edition.isVo());
            cbCouleur.setSelected(edition.isCouleur());

            tfNotesEdition.getChildren().clear();
            tfNotesEdition.getChildren().add(new Text(edition.getNotes()));

            cacheImages = new Image[edition.getCouvertures().size()];
            images.set(FXCollections.observableList(edition.getCouvertures()));
        });
    }

    @Override
    public void setIdEntity(UUID id) {
        // pas la peine de se prendre la tête à faire des bind pour l'album, la fenêtre est recrée à chaque affichage
        // par contre, on utilise des bind pour l'edition en cours de visu

        album.set(albumDao.get(id));
        final Album _album = album.get();
        if (_album == null) throw new EntityNotFoundException();

        titreAlbum.setText(BeanUtils.formatTitre(_album.getTitreAlbum()));
        tome.textProperty().bindBidirectional(_album.tomeProperty(), new IntegerStringConverter());

        String valueParution;
        if (_album.getMoisParution() == null) {
            if (_album.getAnneeParution() != null) {
                DateTimeFormatter format = DateTimeFormatter.ofPattern(I18nSupport.message("format.year"));
                valueParution = _album.getAnneeParution().format(format);
            } else {
                valueParution = null;
            }
        } else {
            YearMonth parution = _album.getAnneeParution().atMonth(_album.getMoisParution());
            DateTimeFormatter format = DateTimeFormatter.ofPattern(I18nSupport.message("format.month-year"));
            valueParution = parution.format(format);
        }
        dateParution.setText(valueParution);

        integrale.setSelected(_album.isIntegrale());
        integraleTomes.setVisible(_album.getTomeDebut() != null && _album.getTomeFin() != null);
        integraleTomes.setText(I18nSupport.message("integrale.de-a", _album.getTomeDebut(), _album.getTomeFin()));
        horsSerie.setSelected(_album.isHorsSerie());

        final EventHandler<ActionEvent> openEntityEventHandler = event -> {
            final Labeled source = (Labeled) event.getSource();
            final AbstractDBEntity entity = (AbstractDBEntity) source.getUserData();
            history.addWaiting(History.HistoryAction.FICHE, entity);
        };
        FlowItem.fillViewFromList(_album.universFullProperty(), lvUnivers, openEntityEventHandler);
        FlowItem.fillViewFromList(_album.scenaristesProperty(), lvScenaristes, openEntityEventHandler);
        FlowItem.fillViewFromList(_album.dessinateursProperty(), lvDessinateurs, openEntityEventHandler);
        FlowItem.fillViewFromList(_album.coloristesProperty(), lvColoristes, openEntityEventHandler);

        //if (!StringUtils.isNullOrEmpty(album.getSujet())) histoire.getStyleClass().add(CSS_FLOW_B0RDER);
        histoire.getChildren().add(new Text(_album.getSujet()));
        //if (!StringUtils.isNullOrEmpty(album.getNotes())) notes.getStyleClass().add(CSS_FLOW_B0RDER);
        notes.getChildren().add(new Text(_album.getNotes()));

        // le getEditions force le lazy loading de la liste
        editions.set(FXCollections.observableList(_album.getEditions()));
        currentEdition.set(editions.get(0));
    }

    private VBox createImagePage(int pageIndex) {
        // même si on dit "pageCount = 0", le factory est appelé: le pageCount sera forcé à 1
        if (images.size() == 0 || pageIndex >= images.size() || pageIndex < 0) return null;

        CouvertureLite couvertureLite = images.get(pageIndex);

        VBox box = new VBox();
        box.setAlignment(Pos.CENTER);
        Label desc = new Label(couvertureLite.getCategorie().getTexte());
        Image image = cacheImages[pageIndex];
        if (image == null) {
            final int height = ((Double) (diaporama.getPrefHeight() - desc.getPrefHeight())).intValue() - 50;
            final byte[] imageStream = couvertureDao.getImageStream(couvertureLite, height, ((Double) diaporama.getPrefWidth()).intValue());
            image = new Image(new ByteArrayInputStream(imageStream));
            cacheImages[pageIndex] = image;
        }
        ImageView iv = new ImageView(image);
        iv.setCursor(Cursor.HAND);
        iv.setOnMouseClicked(event -> {
            history.addWaiting(History.HistoryAction.FICHE, couvertureLite);
        });
        iv.setPreserveRatio(true);
        box.getChildren().addAll(iv);
        box.getChildren().addAll(desc);
        return box;
    }

}

