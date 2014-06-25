package org.tetram.bdtheque.gui.controllers;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Tab;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.tetram.bdtheque.data.services.FormatTitreAlbum;
import org.tetram.bdtheque.data.services.UserPreferences;

/**
 * Created by Thierry on 24/06/2014.
 */
@Controller
public class PreferencesController extends DialogController {

    @Autowired
    UserPreferences userPreferences;

    @FXML
    Button btnOk;

    @FXML
    Button btnCancel;

    @FXML
    private Tab tabOptionsDiverses;

    @FXML
    private Tab tabSiteWeb;

    @FXML
    private Tab tabMonnaies;

    @FXML
    private ChoiceBox<FormatTitreAlbum> formatTitreAlbum;

    @FXML
    void initialize() {
        attachClickListener(btnOk, okBtnClickListener);
        attachClickListener(btnCancel, cancelBtnClickListener);

        formatTitreAlbum.getItems().addAll(FormatTitreAlbum.values());
        formatTitreAlbum.valueProperty().bindBidirectional(userPreferences.formatTitreAlbumProperty());
    }

    public void btnQuitClick(ActionEvent actionEvent) {
        switch (getResult()) {
            case OK:
                userPreferences.save();
            case CANCEL:
                userPreferences.reload(); // on relit après avoir sauvé, c'est pas plus mal meme si ça sert probablement à rien
        }

        // il ne faut surement pas relire les options de userPreferences sinon les bind risque de venir mettre le bazard (surtout sur un CANCEL)
        getDialog().close();
    }

}
