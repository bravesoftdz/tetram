package org.tetram.bdtheque.gui.controllers;

import impl.org.controlsfx.i18n.Localization;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.layout.StackPane;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.SingleConnectionDataSource;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.dao.SerieDao;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.gui.utils.Dialogs;
import org.tetram.bdtheque.gui.utils.History;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.FileStringConverter;
import org.tetram.bdtheque.utils.FileLink;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.IOException;
import java.net.URL;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
@Controller
@FileLink("/org/tetram/bdtheque/gui/main.fxml")
public class MainController extends WindowController {

    @NonNls
    public static final UUID ID_SERIE_SILLAGE = StringUtils.GUIDStringToUUID("{69302EDB-6ED6-4DA3-A2E1-65B7B12BCB51}");

    @Autowired
    private UserPreferences userPreferences;
    @Autowired
    private History history;
    @Autowired
    private SerieDao serieDao;

    @FXML
    private ResourceBundle resources;
    @FXML
    private URL location;

    @FXML
    private MenuBar menuBar;

    @FXML
    private ToolBar toolBar;

    @FXML
    private Button buttonTest;

    @FXML
    private StackPane detailPane;

    @FXML
    private Menu mnuLanguage;

    @FXML
    private MenuItem mnuDBFile;

    @FXML
    private ToggleGroup tgMode;

    @NonNls
    @Autowired
    private SingleConnectionDataSource dataSource;

    private ObjectProperty<ApplicationMode> mode = new SimpleObjectProperty<>(this, "mode", null);

    @FXML
    @FileLink("/org/tetram/bdtheque/config/default_database.properties")
    void initialize() throws IOException {
        // c'est du bidirectionnal parce qu'il n'y a pas de bind auquel on peut passer un StringConverter<File>
        // si le menu est vide c'est qu'on utilise la valeur par défaut de default_database.properties
        mnuDBFile.textProperty().bindBidirectional(userPreferences.databaseProperty(), new FileStringConverter());

        for (int i = 0; i < tgMode.getToggles().size(); i++) {
            final Toggle toggle = tgMode.getToggles().get(i);
            final ApplicationMode applicationMode = ApplicationMode.values()[i];
            toggle.setUserData(applicationMode);
            toggle.setSelected(userPreferences.getModeOuverture().equals(applicationMode));
        }
        tgMode.selectedToggleProperty().addListener(o -> history.addWaiting(((ApplicationMode) tgMode.getSelectedToggle().getUserData()).getHistoryAction()));

        mode.addListener((observable, oldMode, newMode) -> {
            if (newMode == null) return;
            // pratique en développement mais à voir si on garde pour la version finale
            userPreferences.setModeOuverture(newMode);
            userPreferences.save();
        });

        history.addWaiting(userPreferences.getModeOuverture().getHistoryAction());
    }

    public void menuQuitClick(@SuppressWarnings("UnusedParameters") ActionEvent actionEvent) {
        getDialog().close();
    }

    public void buttonTestClick(@SuppressWarnings("UnusedParameters") ActionEvent actionEvent) {
        Serie serie = serieDao.get(ID_SERIE_SILLAGE);
        buttonTest.setText(serie.getTitreSerie());
    }

    @FXML
    public void changeLanguage(ActionEvent event) {
        // certaines traductions sont récupérées à l'initialisation des classes, on n'a pas d'autres choix que de recharger l'appli
        final Locale locale = Localization.getLocale();
        try {
            final MenuItem menuItem = (MenuItem) event.getSource();
            final Locale newLocale = Locale.forLanguageTag(menuItem.getId().substring(4).replace('_', '-'));
            Localization.setLocale(newLocale);
            org.controlsfx.dialog.Dialogs.create()
                    .title(I18nSupport.message(newLocale, "nouvelle.langue"))
                            //.masthead(I18nSupport.message(newLocale, "redemarrage.necessaire"))
                    .message(I18nSupport.message(newLocale, "le.changement.de.langue.sera.effectif.au.prochain.demarrage.de.l.application"))
                    .showInformation();
            userPreferences.setLocale(newLocale);
            userPreferences.save();
        } finally {
            Localization.setLocale(locale);
        }
    }

    public void showPreferences(@SuppressWarnings("UnusedParameters") ActionEvent actionEvent) throws IOException {
        PreferencesController preferencesController = Dialogs.showPreferences(this.getDialog());
        if (preferencesController.getResult() == DialogController.DialogResult.OK)
            SpringContext.CONTEXT.getBean(RepertoireController.class).refresh();
    }

    public ApplicationMode getMode() {
        return mode.get();
    }

    public void setMode(ApplicationMode mode) {
        this.mode.set(mode);
    }

    public ObjectProperty<ApplicationMode> modeProperty() {
        return mode;
    }

    public StackPane getDetailPane() {
        return detailPane;
    }
}
