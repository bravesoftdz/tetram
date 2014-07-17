/**
 * Sample Skeleton for 'repertoire.fxml' Controller Class
 */

package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.fxml.FXML;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.controllers.components.TreeViewController;
import org.tetram.bdtheque.gui.controllers.components.TreeViewMode;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.HashMap;

@Controller
@FileLink("/org/tetram/bdtheque/gui/repertoire.fxml")
public class RepertoireController extends WindowController {

    @Autowired
    private ModeConsultationController modeConsultationController;

    @FXML
    private TabPane tabs;

    @FXML
    private Tab tabAlbums;
    @FXML
    private TreeViewController albumsController;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;

    @FXML
    private Tab tabSeries;
    @FXML
    private TreeViewController seriesController;

    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeViewController universController;

    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeViewController auteursController;

    @FXML
    private Tab tabParabd;
    @FXML
    private TreeViewController parabdController;

    @Autowired
    private UserPreferences userPreferences;

    private ObjectProperty<InfoTab> currentInfoTab = new SimpleObjectProperty<>();

    @SuppressWarnings("unchecked")
    @FXML
    void initialize() {
        // pourquoi ça marchait avant avec <Tab, InfoTab> et que ça ne marche plus maintenant, mystère
        HashMap<String, InfoTab> tabView = new HashMap<>();
        final InfoTab infoTabAlbums = new InfoTab(TypeRepertoireAlbumEntry.PAR_SERIE.mode, albumsController);
        tabView.put(tabAlbums.getId(), infoTabAlbums);
        tabView.put(tabSeries.getId(), new InfoTab(TreeViewMode.SERIES, seriesController));
        tabView.put(tabUnivers.getId(), new InfoTab(TreeViewMode.UNIVERS, universController));
        tabView.put(tabAuteurs.getId(), new InfoTab(TreeViewMode.PERSONNES, auteursController));
        tabView.put(tabParabd.getId(), new InfoTab(TreeViewMode.PARAB_SERIE, parabdController));

        infoTabAlbums.modeProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.treeViewController.setMode(infoTabAlbums.getMode());
        });

        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.setMode(newValue.mode);
        });

        currentInfoTab.addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                newValue.treeViewController.setMode(newValue.getMode());
        });

        // on se fiche du tab, il doit juste être différent de tabAlbums
        tabs.getSelectionModel().select(tabSeries);
        tabs.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                currentInfoTab.set(tabView.get(newValue.getId()));
        });
        tabs.getSelectionModel().select(tabAlbums);
    }

    public void refresh() {
        currentInfoTab.getValue().treeViewController.refresh();
    }

    private enum TypeRepertoireAlbumEntry {
        PAR_TITRE(I18nSupport.message("Titre"), TreeViewMode.ALBUMS),
        PAR_SERIE(I18nSupport.message("Série"), TreeViewMode.ALBUMS_SERIE),
        PAR_EDITEUR(I18nSupport.message("Editeur"), TreeViewMode.ALBUMS_EDITEUR),
        PAR_GENRE(I18nSupport.message("Genre"), TreeViewMode.ALBUMS_GENRE),
        PAR_ANNEE(I18nSupport.message("Annee.de.parution"), TreeViewMode.ALBUMS_ANNEE),
        PAR_COLLECTION(I18nSupport.message("Collection"), TreeViewMode.ALBUMS_COLLECTION);

        String label;
        TreeViewMode mode;

        TypeRepertoireAlbumEntry(String label, TreeViewMode mode) {
            this.label = label;
            this.mode = mode;
        }

        public String toString() {
            return label;
        }

    }

    @SuppressWarnings("UnusedDeclaration")
    private class InfoTab {
        private final ObjectProperty<TreeViewMode> mode = new SimpleObjectProperty<>(this, "mode", null);
        private final TreeViewController treeViewController;

        public InfoTab(TreeViewMode mode, TreeViewController treeViewController) {
            setMode(mode);
            this.treeViewController = treeViewController;
        }

        public TreeViewMode getMode() {
            return mode.get();
        }

        public void setMode(TreeViewMode mode) {
            this.mode.set(mode);
        }

        public ObjectProperty<TreeViewMode> modeProperty() {
            return mode;
        }

    }

}
