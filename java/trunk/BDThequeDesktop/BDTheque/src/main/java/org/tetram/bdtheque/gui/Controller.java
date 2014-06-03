package org.tetram.bdtheque.gui;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.mappers.CollectionMapper;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

public class Controller {

    public static final UUID ID_COLLECTION_GENERATION_COMICS_PANINI = StringUtils.GUIDStringToUUID("{085B0C9C-7608-4B5E-A2B6-968D9FDB56E8}");

    @FXML
    Button button;

    public void buttonClick(ActionEvent actionEvent) {
        Database db = Database.getInstance();
        button.setText(db.getApplicationContext().getBean(CollectionMapper.class).getCollectionById(ID_COLLECTION_GENERATION_COMICS_PANINI).getNomCollection());
    }
}
