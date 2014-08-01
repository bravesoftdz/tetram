/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CollectionMapper.java
 * Last modified by Tetram, on 2014-08-01T12:33:57CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/CollectionMapper.xml")
public interface CollectionMapper extends BaseMapperInterface {
    CollectionLite getCollectionLiteById(@Param("id") UUID id);

    List<CollectionLite> getListCollectionLiteByEditeur(@Param("id") UUID id);

    Collection getCollectionById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    UUID checkUniqueCollection(Collection collection);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int createCollection(Collection collection);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int updateCollection(Collection collection);

    /**
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int deleteCollection(UUID id);

    List<CollectionLite> getListCollectionLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<InitialeWithEntity<Character, CollectionLite>> searchListCollectionLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
