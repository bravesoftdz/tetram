package org.tetram.bdtheque.gui;

import javafx.event.ActionEvent;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.CollectionDao;

public class Controller {
    public void buttonClick(ActionEvent actionEvent) {
        Database db = new Database();
        db.getSession().getMapper(CollectionDao.class).getCollectionById(null);
    }
}
