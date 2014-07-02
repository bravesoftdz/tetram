package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.CollectionLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Collection.xml")
public interface CollectionMapper extends BaseMapperInterface {
    CollectionLite getCollectionLiteById(UUID id);

    List<CollectionLite> getListCollectionLiteByEditeurId(UUID id);

    Collection getCollectionById(UUID id);
}
