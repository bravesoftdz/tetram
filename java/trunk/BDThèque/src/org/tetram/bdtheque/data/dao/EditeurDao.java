package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.lite.EditeurLite;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public interface EditeurDao {
    EditeurLite getEditeurLiteById(UUID id);

    Editeur getEditeurById(UUID id);
}
