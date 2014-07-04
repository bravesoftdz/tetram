package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Editeur.xml")
public interface EditeurMapper extends BaseMapperInterface {
    EditeurLite getEditeurLiteById(UUID id);

    Editeur getEditeurById(UUID id);
}
