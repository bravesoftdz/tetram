/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionMapper.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.utils.FileLink;

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
