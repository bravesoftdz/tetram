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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.PhotoLite;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.dao.ParaBDDao;
import org.tetram.bdtheque.data.dao.PhotoLiteDao;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.ModeConsultationController;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.gui.utils.FlowItem;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.I18nSupport;

import java.io.ByteArrayInputStream;
import java.text.MessageFormat;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Created by Thierry on 11/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheParabd.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheParabd-screenshot.jpg")
})
public class FicheParaBDController extends WindowController implements ConsultationController {

    @Autowired
    private ParaBDDao paraBDDao;
    @Autowired
    private PhotoLiteDao photoLiteDao;
    @Autowired
    private ModeConsultationController modeConsultationController;
    @Autowired
    private UserPreferences userPreferences;

    @FXML
    private Label lbTitre;
    @FXML
    private Hyperlink lbSerie;
    @FXML
    private Label lbType;
    @FXML
    private Label lbAnnee;
    @FXML
    private CheckBox cbDedicace;
    @FXML
    private CheckBox cbNumerote;
    @FXML
    private Pagination diaporama;
    @FXML
    private FlowPane lvCreateurs;
    @FXML
    private FlowPane lvUnivers;
    @FXML
    private TextFlow tfDescription;
    @FXML
    private CheckBox cbOffert;
    @FXML
    private CheckBox cbStock;
    @FXML
    private Label lbPrix;
    @FXML
    private Label lbAcheteLe;
    @FXML
    private Label lbDateAchat;
    @FXML
    private Label lbCote;

    private ObjectProperty<ParaBD> parabd = new SimpleObjectProperty<>();
    private ListProperty<PhotoLite> images = new SimpleListProperty<>();
    private Image[] cacheImages = null;

    @FXML
    public void initialize() {
        diaporama.pageCountProperty().bind(images.sizeProperty());
        diaporama.pageCountProperty().addListener((observable, oldValue, newValue) -> diaporama.setCurrentPageIndex(0));
        diaporama.visibleProperty().bind(Bindings.greaterThan(diaporama.pageCountProperty(), 0));
        diaporama.setPageFactory(this::createImagePage);
    }

    @Override
    public void setIdEntity(UUID id) {
        parabd.set(paraBDDao.get(id));
        final ParaBD _parabd = parabd.get();
        if (_parabd == null) throw new EntityNotFoundException();

        lbTitre.setText(BeanUtils.formatTitre(_parabd.getTitreParaBD()));
        if (_parabd.getSerie() != null) {
            lbSerie.setText(BeanUtils.formatTitre(_parabd.getSerie().getTitreSerie()));
            EntityWebHyperlink.addToLabeled(lbSerie, _parabd.getSerie().getSiteWeb());
        }
        lbType.setText(_parabd.getCategorieParaBD().getTexte());
        if (_parabd.getAnneeEdition() != null)
            lbAnnee.setText(_parabd.getAnneeEdition().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.year"))));
        cbDedicace.setSelected(_parabd.isDedicace());
        cbNumerote.setSelected(_parabd.isNumerote());

        final EventHandler<ActionEvent> openEntityEventHandler = event -> {
            final Labeled source = (Labeled) event.getSource();
            final AbstractDBEntity entity = (AbstractDBEntity) source.getUserData();
            modeConsultationController.showConsultationForm(entity);
        };
        FlowItem.fillViewFromList(_parabd.getUnivers(), lvUnivers, openEntityEventHandler);
        FlowItem.fillViewFromList(_parabd.getAuteurs(), lvCreateurs, openEntityEventHandler);
        tfDescription.getChildren().add(new Text(_parabd.getNotes()));

        cbOffert.setSelected(_parabd.isOffert());
        cbStock.setSelected(_parabd.isStock());
        lbCote.setText(_parabd.getAnneeCote() == null ? null : MessageFormat.format("{0} ({0})", userPreferences.getCurrencyFormatter().format(_parabd.getPrixCote()), _parabd.getAnneeCote().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.year")))));
        lbAcheteLe.setText(_parabd.isOffert() ? "Offert le :" : "Acheté le :");
        lbDateAchat.setText(_parabd.getDateAchat() == null ? null : _parabd.getDateAchat().format(DateTimeFormatter.ofPattern(I18nSupport.message("format.date"))));
        lbPrix.setText(_parabd.getPrix() == null ? null : userPreferences.getCurrencyFormatter().format(_parabd.getPrix()));

        cacheImages = new Image[_parabd.getPhotos().size()];
        images.set(FXCollections.observableList(_parabd.getPhotos()));
    }

    private VBox createImagePage(int pageIndex) {
        // même si on dit "pageCount = 0", le factory est appelé: le pageCount sera forcé à 1
        if (images.size() == 0 || pageIndex >= images.size() || pageIndex < 0) return null;

        PhotoLite photoLite = images.get(pageIndex);

        VBox box = new VBox();
        box.setAlignment(Pos.CENTER);
        Label desc = new Label(photoLite.getCategorie().getTexte());
        Image image = cacheImages[pageIndex];
        if (image == null) {
            final int height = ((Double) (diaporama.getPrefHeight() - desc.getPrefHeight())).intValue() - 50;
            final byte[] imageStream = photoLiteDao.getImageStream(photoLite, height, ((Double) diaporama.getPrefWidth()).intValue());
            image = new Image(new ByteArrayInputStream(imageStream));
            cacheImages[pageIndex] = image;
        }
        ImageView iv = new ImageView(image);
        iv.setCursor(Cursor.HAND);
        iv.setOnMouseClicked(event -> {
            modeConsultationController.showConsultationForm(photoLite);
        });
        iv.setPreserveRatio(true);
        box.getChildren().addAll(iv);
        box.getChildren().addAll(desc);
        return box;
    }
}

