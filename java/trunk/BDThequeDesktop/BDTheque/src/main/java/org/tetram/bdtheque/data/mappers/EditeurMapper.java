package org.tetram.bdtheque.data.mappers;

import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.EditeurLite;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public interface EditeurMapper {
    EditeurLite getEditeurLiteById(UUID id);

    Editeur getEditeurById(UUID id);
}
