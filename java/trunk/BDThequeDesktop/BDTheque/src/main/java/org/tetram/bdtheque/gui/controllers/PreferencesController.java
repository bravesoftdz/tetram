package org.tetram.bdtheque.gui.controllers;

import javafx.application.Platform;
import javafx.beans.binding.Bindings;
import javafx.beans.property.BooleanProperty;
import javafx.beans.property.BooleanPropertyBase;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.ObjectPropertyBase;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableNumberValue;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.scene.Node;
import javafx.scene.control.*;
import javafx.scene.layout.BorderPane;
import javafx.stage.DirectoryChooser;
import javafx.util.StringConverter;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.services.FormatTitreAlbum;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.utils.FileUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.io.File;
import java.util.HashMap;
import java.util.Locale;

/**
 * Created by Thierry on 24/06/2014.
 */
@Controller
public class PreferencesController extends DialogController {

    UserPreferencesProperties preferencesProperties;
    @Autowired
    private UserPreferences userPreferences;
    @FXML
    private Button btnOk;
    @FXML
    private Button btnCancel;
    @FXML
    private ToggleButton btnOptionsDiverses;
    @FXML
    private ToggleButton btnSiteWeb;
    @FXML
    private ToggleButton btnMonnaies;
    @FXML
    private ScrollPane tabOptionsDiverses;
    @FXML
    private ChoiceBox<FormatTitreAlbum> formatTitreAlbum;
    @FXML
    private CheckBox serieObligatoireAlbums;
    @FXML
    private CheckBox serieObligatoireParaBD;
    @FXML
    private CheckBox antiAliasing;
    @FXML
    private CheckBox imagesStockees;
    @FXML
    private Label repImages;
    @FXML
    private BorderPane content;
    @FXML
    private ToggleGroup btnTabGroup;

    @FXML
    void initialize() {
        attachClickListener(btnOk, okBtnClickListener);
        attachClickListener(btnCancel, cancelBtnClickListener);

        HashMap<ToggleButton, Node> buttonNodeHashMap = new HashMap<>();
        buttonNodeHashMap.put(btnOptionsDiverses, tabOptionsDiverses);
        buttonNodeHashMap.put(btnMonnaies, null);
        buttonNodeHashMap.put(btnSiteWeb, null);

        ObservableNumberValue tabWidth = null;
        for (ToggleButton toggleButton : buttonNodeHashMap.keySet())
            tabWidth = tabWidth == null ? toggleButton.widthProperty() : Bindings.max(toggleButton.widthProperty(), tabWidth);

        for (ToggleButton toggleButton : buttonNodeHashMap.keySet()) {
            toggleButton.minWidthProperty().bind(tabWidth);
            toggleButton.setUserData(buttonNodeHashMap.get(toggleButton));
            toggleButton.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    content.setCenter(buttonNodeHashMap.get(toggleButton));
                }
            });
        }

        btnTabGroup.selectedToggleProperty().addListener(new ChangeListener<Toggle>() {
            @Override
            public void changed(ObservableValue<? extends Toggle> observable, Toggle oldButton, Toggle newButton) {
                if (newButton == null)
                    oldButton.setSelected(true);
            }
        });

        preferencesProperties = new UserPreferencesProperties();

        formatTitreAlbum.getItems().addAll(FormatTitreAlbum.values());
        formatTitreAlbum.valueProperty().bindBidirectional(preferencesProperties.formatTitreAlbumProperty);

        serieObligatoireAlbums.selectedProperty().bindBidirectional(preferencesProperties.serieObligatoireAlbumsProperty);
        serieObligatoireParaBD.selectedProperty().bindBidirectional(preferencesProperties.serieObligatoireParaBDProperty);
        antiAliasing.selectedProperty().bindBidirectional(preferencesProperties.antiAliasingProperty);
        imagesStockees.selectedProperty().bindBidirectional(preferencesProperties.imagesStockeesProperty);
        Bindings.bindBidirectional(repImages.textProperty(), preferencesProperties.repImagesProperty, new StringConverter<File>() {
            @Override
            public String toString(File object) {
                return object == null ? null : StringUtils.notNull(object.getAbsolutePath());
            }

            @Override
            public File fromString(String string) {
                return StringUtils.isNullOrEmpty(string) ? null : new File(string);
            }
        });

        content.setCenter(null);
        Platform.runLater(new Runnable() {
            @Override
            public void run() {
                btnOptionsDiverses.fire();
            }
        });
    }

    @FXML
    public void btnQuitClick(ActionEvent actionEvent) {
        switch (getResult()) {
            case OK:
                userPreferences.save();
            case CANCEL:
                userPreferences.reload(); // on relit après avoir sauvé, c'est pas plus mal meme si ça sert probablement à rien
        }

        // il ne faut surtout pas relire les options de userPreferences sinon les bind risque de venir mettre le bazard (surtout sur un CANCEL)
        getDialog().close();
    }

    @FXML
    void btnChooseFolderClick(ActionEvent event) {
        final DirectoryChooser directoryChooser = new DirectoryChooser();
        if (FileUtils.isNotNullAndExists(preferencesProperties.repImagesProperty.get()))
            directoryChooser.setInitialDirectory(preferencesProperties.repImagesProperty.get());
        else
            directoryChooser.setInitialDirectory(null);
        final File newDirectory = directoryChooser.showDialog(getDialog());
        if (newDirectory != null)
            preferencesProperties.repImagesProperty.set(newDirectory);
    }


    class UserPreferencesProperties {
        ObjectProperty<File> repImagesProperty = new ObjectPropertyBase<File>() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "repImagesProperty";
            }

            @Override
            public File get() {
                super.get();
                return userPreferences.getRepImages();
            }

            @Override
            public void set(File newValue) {
                userPreferences.setRepImages(newValue);
                super.set(newValue);
            }
        };
        ObjectProperty<FormatTitreAlbum> formatTitreAlbumProperty = new ObjectPropertyBase<FormatTitreAlbum>() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "formatTitreAlbum";
            }

            @Override
            public FormatTitreAlbum get() {
                super.get();
                return userPreferences.getFormatTitreAlbum();
            }

            @Override
            public void set(FormatTitreAlbum newValue) {
                userPreferences.setFormatTitreAlbum(newValue);
                super.set(newValue);
            }
        };
        BooleanProperty serieObligatoireAlbumsProperty = new BooleanPropertyBase() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "serieObligatoireAlbumsProperty";
            }

            @Override
            public boolean get() {
                super.get();
                return userPreferences.isSerieObligatoireAlbums();
            }

            @Override
            public void set(boolean newValue) {
                userPreferences.setSerieObligatoireAlbums(newValue);
                super.set(newValue);
            }
        };
        BooleanProperty serieObligatoireParaBDProperty = new BooleanPropertyBase() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "serieObligatoireParaBDProperty";
            }

            @Override
            public boolean get() {
                super.get();
                return userPreferences.isSerieObligatoireParaBD();
            }

            @Override
            public void set(boolean newValue) {
                userPreferences.setSerieObligatoireParaBD(newValue);
                super.set(newValue);
            }
        };
        BooleanProperty antiAliasingProperty = new BooleanPropertyBase() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "antiAliasingProperty";
            }

            @Override
            public boolean get() {
                super.get();
                return userPreferences.isAntiAliasing();
            }

            @Override
            public void set(boolean newValue) {
                userPreferences.setAntiAliasing(newValue);
                super.set(newValue);
            }
        };
        BooleanProperty imagesStockeesProperty = new BooleanPropertyBase() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "imagesStockeesProperty";
            }

            @Override
            public boolean get() {
                super.get();
                return userPreferences.isImagesStockees();
            }

            @Override
            public void set(boolean newValue) {
                userPreferences.setImagesStockees(newValue);
                super.set(newValue);
            }
        };
        ObjectProperty<Locale> localeProperty = new ObjectPropertyBase<Locale>() {
            @Override
            public Object getBean() {
                return this;
            }

            @NonNls
            @Override
            public String getName() {
                return "localeProperty";
            }

            @Override
            public Locale get() {
                super.get();
                return userPreferences.getLocale();
            }

            @Override
            public void set(Locale newValue) {
                userPreferences.setLocale(newValue);
                super.set(newValue);
            }
        };
    }
}
