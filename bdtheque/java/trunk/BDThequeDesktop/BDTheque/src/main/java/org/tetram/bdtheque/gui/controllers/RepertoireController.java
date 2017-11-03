/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * RepertoireController.java
 * Last modified by Tetram, on 2014-08-27T10:27:44CEST
 */

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
import org.tetram.bdtheque.gui.controllers.includes.TreeViewMode;
import org.tetram.bdtheque.gui.controllers.includes.TreeViewSearchController;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.I18nSupport;

import java.util.HashMap;

@Controller
@FileLink("/org/tetram/bdtheque/gui/repertoire.fxml")
public class RepertoireController extends WindowController {

    private final ObjectProperty<InfoTab> currentInfoTab = new SimpleObjectProperty<>();
    @FXML
    private TabPane tabs;
    @FXML
    private Tab tabAlbums;
    @FXML
    private TreeViewSearchController albumsController;
    @FXML
    private ChoiceBox<TypeRepertoireAlbumEntry> repertoireGroup;
    @FXML
    private Tab tabSeries;
    @FXML
    private TreeViewSearchController seriesController;
    @FXML
    private Tab tabUnivers;
    @FXML
    private TreeViewSearchController universController;
    @FXML
    private Tab tabAuteurs;
    @FXML
    private TreeViewSearchController auteursController;
    @FXML
    private Tab tabParabd;
    @FXML
    private TreeViewSearchController parabdController;
    @Autowired
    private UserPreferences userPreferences;

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
        tabView.put(tabParabd.getId(), new InfoTab(TreeViewMode.PARABD_SERIE, parabdController));

        infoTabAlbums.modeProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.treeViewController.getTreeViewController().setMode(infoTabAlbums.getMode());
        });

        repertoireGroup.getItems().addAll(TypeRepertoireAlbumEntry.values());
        repertoireGroup.setValue(TypeRepertoireAlbumEntry.PAR_SERIE);
        repertoireGroup.valueProperty().addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                infoTabAlbums.setMode(newValue.mode);
        });

        currentInfoTab.addListener((observable, oldValue, newValue) -> {
            if (newValue != null)
                newValue.treeViewController.getTreeViewController().setMode(newValue.getMode());
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
        currentInfoTab.getValue().treeViewController.getTreeViewController().refreshTree();
    }

    private enum TypeRepertoireAlbumEntry {
        PAR_TITRE(I18nSupport.message("Titre"), TreeViewMode.ALBUMS),
        PAR_SERIE(I18nSupport.message("Série/one"), TreeViewMode.ALBUMS_SERIE),
        PAR_EDITEUR(I18nSupport.message("Editeur/one"), TreeViewMode.ALBUMS_EDITEUR),
        PAR_GENRE(I18nSupport.message("Genre/one"), TreeViewMode.ALBUMS_GENRE),
        PAR_ANNEE(I18nSupport.message("Annee.de.parution"), TreeViewMode.ALBUMS_ANNEE),
        PAR_COLLECTION(I18nSupport.message("Collection/one"), TreeViewMode.ALBUMS_COLLECTION);

        final String label;
        final TreeViewMode mode;

        TypeRepertoireAlbumEntry(String label, TreeViewMode mode) {
            this.label = label;
            this.mode = mode;
        }

        public String toString() {
            return label;
        }

    }


    private class InfoTab {
        private final ObjectProperty<TreeViewMode> mode = new SimpleObjectProperty<>(this, "mode", null);
        private final TreeViewSearchController treeViewController;

        public InfoTab(TreeViewMode mode, TreeViewSearchController treeViewController) {
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
