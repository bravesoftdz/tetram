/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Tab;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.SpringContext;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.gui.utils.InitialeEntity;
import org.tetram.bdtheque.utils.I18nSupport;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

@Controller
public class RepertoireController extends WindowController {

    @FXML // ResourceBundle that was given to the FXMLLoader
    private ResourceBundle resources;
    @FXML // URL location of the FXML file that was given to the FXMLLoader
    private URL location;

    @FXML
    private Tab tabAlbums;
    @FXML
    private TreeView<AbstractEntity> tvAlbums;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;

    @FXML
    private Tab tabSeries;
    @FXML
    private TreeView<AbstractEntity> tvSeries;
    @Autowired
    private SerieLiteDao serieLiteDao;

    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeView<AbstractEntity> tvUnivers;
    @Autowired
    private UniversLiteDao universLiteDao;

    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeView<AbstractEntity> tvAuteurs;
    @Autowired
    private PersonneLiteDao personneLiteDao;

    @FXML
    private Tab tabParabd;
    @FXML
    private TreeView<AbstractEntity> tvParabd;
    @Autowired
    private ParaBDLiteDao paraBDLiteDao;

    @FXML
    void initialize() {
        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener(new ChangeListener<TypeRepertoireAlbumEntry>() {
            @Override
            public void changed(ObservableValue<? extends TypeRepertoireAlbumEntry> observable, TypeRepertoireAlbumEntry oldValue, TypeRepertoireAlbumEntry newValue) {
                if (newValue != null)
                    tvAlbums.setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(newValue.daoClass)));
            }
        });

        refresh();
    }

    public void refresh() {
        tvAlbums.setRoot(new InitialTreeItem(SpringContext.CONTEXT.getBean(repertoireGroup.getValue().daoClass)));
        tvSeries.setRoot(new InitialTreeItem(serieLiteDao));
        tvUnivers.setRoot(new InitialTreeItem(universLiteDao));
        tvAuteurs.setRoot(new InitialTreeItem(personneLiteDao));
        tvParabd.setRoot(new InitialTreeItem(paraBDLiteDao));
    }

    enum TypeRepertoireAlbumEntry {
        PAR_TITRE(I18nSupport.message("Titre"), AlbumLiteDao.class),
        PAR_SERIE(I18nSupport.message("Série"), AlbumLiteSerieDao.class),
        PAR_EDITEUR(I18nSupport.message("Editeur"), AlbumLiteEditeurDao.class),
        PAR_GENRE(I18nSupport.message("Genre"), AlbumLiteGenreDao.class),
        PAR_ANNEE(I18nSupport.message("Annee.de.parution"), AlbumLiteAnneeDao.class),
        PAR_COLLECTION(I18nSupport.message("Collection"), AlbumLiteCollectionDao.class);

        String label;

        Class<? extends RepertoireLiteDao> daoClass;

        TypeRepertoireAlbumEntry(String label, Class<? extends RepertoireLiteDao> daoClass) {
            this.label = label;
            this.daoClass = daoClass;
        }

        public String toString() {
            return label;
        }

    }

    private class InitialTreeItem extends TreeItem<AbstractEntity> {
        private final RepertoireLiteDao dao;
        private boolean isLeaf;
        private boolean isFirstTimeChildren = true;
        private boolean isFirstTimeLeaf = true;

        public InitialTreeItem(RepertoireLiteDao dao) {
            this(dao, null);
        }

        public InitialTreeItem(RepertoireLiteDao dao, AbstractEntity value) {
            super(value);
            this.dao = dao;
        }

        @Override
        public ObservableList<TreeItem<AbstractEntity>> getChildren() {
            if (isFirstTimeChildren) {
                isFirstTimeChildren = false;
                super.getChildren().setAll(buildChildren(this));
            }
            return super.getChildren();
        }

        @Override
        public boolean isLeaf() {
            if (isFirstTimeLeaf) {
                isFirstTimeLeaf = false;
                isLeaf = getValue() instanceof AbstractDBEntity;
            }
            return isLeaf;
        }

        @SuppressWarnings("unchecked")
        private ObservableList<InitialTreeItem> buildChildren(InitialTreeItem treeItem) {
            List<? extends AbstractEntity> items;
            if (treeItem.getParent() == null)
                items = dao.getInitiales(null);
            else
                items = dao.getListEntitiesByInitiale((InitialeEntity) treeItem.getValue(), null);

            ObservableList<InitialTreeItem> children = FXCollections.observableArrayList();
            if (items != null) {
                for (AbstractEntity item : items) children.add(new InitialTreeItem(dao, item));
                return children;
            }

            return FXCollections.emptyObservableList();
        }

    }
}
