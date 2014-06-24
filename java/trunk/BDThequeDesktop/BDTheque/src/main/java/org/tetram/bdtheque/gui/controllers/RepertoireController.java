/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Tab;
import javafx.scene.control.TreeItem;
import javafx.scene.control.TreeView;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AbstractEntity;
import org.tetram.bdtheque.data.dao.AlbumLiteDao;
import org.tetram.bdtheque.data.dao.RepertoireLiteDao;
import org.tetram.bdtheque.data.dao.SerieLiteDao;
import org.tetram.bdtheque.gui.utils.InitialEntity;

import java.net.URL;
import java.util.List;
import java.util.ResourceBundle;

@Controller
public class RepertoireController extends WindowController {

    @FXML // ResourceBundle that was given to the FXMLLoader
    private ResourceBundle resources;

    @FXML // URL location of the FXML file that was given to the FXMLLoader
    private URL location;

    @FXML // fx:id="tabSeries"
    private Tab tabSeries; // Value injected by FXMLLoader

    @FXML // fx:id="tvAlbums"
    private TreeView<AbstractEntity> tvAlbums; // Value injected by FXMLLoader

    @FXML // fx:id="tvSeries"
    private TreeView<AbstractEntity> tvSeries; // Value injected by FXMLLoader

    @FXML // fx:id="tabAlbums"
    private Tab tabAlbums; // Value injected by FXMLLoader

    @Autowired
    private AlbumLiteDao albumLiteDao;

    @Autowired
    private SerieLiteDao serieLiteDao;

    @FXML
        // This method is called by the FXMLLoader when initialization is complete
    void initialize() {
        assert tabSeries != null : "fx:id=\"tabSeries\" was not injected: check your FXML file 'repertoire.fxml'.";
        assert tvAlbums != null : "fx:id=\"tvAlbums\" was not injected: check your FXML file 'repertoire.fxml'.";
        assert tvSeries != null : "fx:id=\"tvSeries\" was not injected: check your FXML file 'repertoire.fxml'.";
        assert tabAlbums != null : "fx:id=\"tabAlbums\" was not injected: check your FXML file 'repertoire.fxml'.";

        tvAlbums.setRoot(new InitialTreeItem(albumLiteDao));
        tvSeries.setRoot(new InitialTreeItem(serieLiteDao));
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
                items = dao.getListInitiales(null);
            else
                items = dao.getListEntitiesByInitiale(((InitialEntity) treeItem.getValue()).getValue(), null);

            ObservableList<InitialTreeItem> children = FXCollections.observableArrayList();
            if (items != null) {
                for (AbstractEntity item : items) children.add(new InitialTreeItem(dao, item));
                return children;
            }

            return FXCollections.emptyObservableList();
        }

    }
}
