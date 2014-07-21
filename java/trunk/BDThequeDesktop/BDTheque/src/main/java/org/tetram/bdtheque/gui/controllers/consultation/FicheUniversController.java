package org.tetram.bdtheque.gui.controllers.consultation;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.Hyperlink;
import javafx.scene.control.Label;
import javafx.scene.text.Text;
import javafx.scene.text.TextFlow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.ParaBDLite;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.data.bean.abstractentities.BaseParaBD;
import org.tetram.bdtheque.data.dao.AlbumLiteSerieDao;
import org.tetram.bdtheque.data.dao.ParaBDLiteDao;
import org.tetram.bdtheque.data.dao.UniversDao;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 11/07/2014.
 */
@Controller
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
@FileLinks({
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheUnivers.fxml"),
        @FileLink("/org/tetram/bdtheque/gui/consultation/ficheUnivers-screenshot.jpg")
})
public class FicheUniversController extends WindowController implements ConsultationController {

    @Autowired
    private UniversDao universDao;
    @Autowired
    private AlbumLiteSerieDao albumLiteSerieDao;
    @Autowired
    private ParaBDLiteDao paraBDLiteDao;
    @Autowired
    private History history;

    @FXML
    private Label lbNom;
    @FXML
    private Hyperlink lbUniversParent;
    @FXML
    private TextFlow tfDescription;
    @FXML
    private TreeViewController albumsController;
    @FXML
    private TreeViewController parabdController;

    private ObjectProperty<Univers> univers = new SimpleObjectProperty<>();

    @FXML
    public void initialize() {
        lbUniversParent.setOnAction(event -> {
            if (event.getTarget() != lbUniversParent.getGraphic() && univers.get().getUniversParent() != null)
                history.addWaiting(History.HistoryAction.FICHE, univers.get().getUniversParent());
        });
    }

    @SuppressWarnings("unchecked")
    @Override
    public void setIdEntity(UUID id) {
        univers.set(universDao.get(id));
        final Univers _univers = univers.get();
        if (_univers == null) throw new EntityNotFoundException();

        lbNom.setText(BeanUtils.formatTitre(_univers.getNomUnivers()));
        if (_univers.getUniversParent() != null)
            lbUniversParent.setText(BeanUtils.formatTitre(_univers.getUniversParent().getNomUnivers()));
        tfDescription.getChildren().add(new Text(_univers.getDescription()));

        @SuppressWarnings("HardCodedStringLiteral") final String filtreBrancheUnivers = String.format("branche_univers containing '%s'", StringUtils.UUIDToGUIDString(_univers.getId()));

        albumsController.setFinalEntityClass(AlbumLite.class);
        albumsController.setClickToShow(true);
        albumsController.setOnGetLabel(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null)
                return null;
            else if (entity instanceof BaseAlbum)
                return ((BaseAlbum) entity).buildLabel(false);
            else
                return entity.buildLabel();
        });
        albumsController.onGetChildrenProperty().setValue(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null) {
                // c'est la racine
                return albumLiteSerieDao.getInitiales(filtreBrancheUnivers);
            } else if (entity instanceof InitialeEntity) {
                // c'est le niveau 1
                return albumLiteSerieDao.getListEntitiesByInitiale((InitialeEntity<UUID>) entity, filtreBrancheUnivers);
            }
            return null;
        });

        parabdController.setFinalEntityClass(ParaBDLite.class);
        parabdController.setClickToShow(true);
        parabdController.setOnGetLabel(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null)
                return null;
            else if (entity instanceof BaseParaBD)
                return ((BaseParaBD) entity).buildLabel(false);
            else
                return entity.buildLabel();
        });
        parabdController.onGetChildrenProperty().setValue(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null) {
                // c'est la racine
                return paraBDLiteDao.getInitiales(filtreBrancheUnivers);
            } else if (entity instanceof InitialeEntity) {
                // c'est le niveau 1
                return paraBDLiteDao.getListEntitiesByInitiale((InitialeEntity<UUID>) entity, filtreBrancheUnivers);
            }
            return null;
        });
    }
}
