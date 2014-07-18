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
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractEntity;
import org.tetram.bdtheque.data.bean.abstractentities.BaseAlbum;
import org.tetram.bdtheque.data.dao.AlbumLiteSerieDaoImpl;
import org.tetram.bdtheque.data.dao.PersonneDao;
import org.tetram.bdtheque.gui.controllers.WindowController;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;
import org.tetram.bdtheque.gui.utils.EntityWebHyperlink;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.FileLinks;
import org.tetram.bdtheque.utils.TypeUtils;

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

    @Autowired
    private PersonneDao personneDao;

    @FXML
    private TreeViewController seriesController;

    @FXML
    private Label lbNom;
    @FXML
    private TextFlow tfBiographie;

    private ObjectProperty<Personne> personne = new SimpleObjectProperty<>();

    @SuppressWarnings("unchecked")
    @Override
    public void setIdEntity(UUID id) {
        personne.set(personneDao.get(id));
        final Personne _personne = personne.get();
        if (_personne == null) throw new EntityNotFoundException();

        lbNom.setText(BeanUtils.formatTitre(_personne.getNomPersonne()));
        EntityWebHyperlink.addToLabeled(lbNom, _personne.siteWebProperty());
        tfBiographie.getChildren().add(new Text(_personne.getBiographie()));

        seriesController.setClickToShow(true);
        seriesController.setOnGetLabel(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null)
                return null;
            else if (BaseAlbum.class.isAssignableFrom(entity.getClass()))
                return ((BaseAlbum) entity).buildLabel(false);
            else if (TypeUtils.isNullOrZero(((AbstractDBEntity) entity).getId()))
                return AlbumLiteSerieDaoImpl.UNKNOWN_LABEL;
            else
                return entity.buildLabel();
        });
        seriesController.setOnIsLeaf(treeItem -> {
            return treeItem.getValue() != null && AlbumLite.class.isAssignableFrom(treeItem.getValue().getClass());
        });
        seriesController.onGetChildrenProperty().setValue(treeItem -> {
            final AbstractEntity entity = treeItem.getValue();
            if (entity == null) {
                // c'est la racine
                return _personne.getSeries();
            } else if (Serie.class.isAssignableFrom(entity.getClass())) {
                // c'est le niveau 1
                return ((Serie) entity).getAlbums();
            }
            return null;
        });
    }
}
