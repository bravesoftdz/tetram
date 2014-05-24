package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.lite.CollectionLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public interface CollectionDao {
    CollectionLite getCollectionLiteById(UUID id);
    List<CollectionLite> getListCollectionLiteByEditeurId(UUID id);
    Collection getCollectionById(UUID id);
}
