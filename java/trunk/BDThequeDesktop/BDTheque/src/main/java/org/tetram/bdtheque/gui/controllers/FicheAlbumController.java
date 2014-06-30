package org.tetram.bdtheque.gui.controllers;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.data.dao.mappers.XMLFile;
import org.tetram.bdtheque.gui.utils.EntityNotFoundException;

import java.util.UUID;

/**
 * Created by Thierry on 30/06/2014.
 */
@XMLFile("/org/tetram/bdtheque/gui/consultation/ficheAlbum.fxml")
public class FicheAlbumController extends WindowController {

    @Autowired
    private AlbumDao albumDao;

    private ObjectProperty<Album> album = new SimpleObjectProperty<>(this, "album", null);

    public void showAlbum(UUID idAlbum) {
        album.set(albumDao.get(idAlbum));
        if (album.get() == null)
            throw new EntityNotFoundException();
    }

}
