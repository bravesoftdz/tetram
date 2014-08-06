/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditionMapper.java
 * Last modified by Tetram, on 2014-08-01T12:33:57CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Edition;
import org.tetram.bdtheque.data.bean.EditionLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/EditionMapper.xml")
public interface EditionMapper extends BaseMapperInterface {
    EditionLite getEditionLiteById(@Param("id") UUID id);

    Edition getEditionById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int createEdition(Edition edition);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int updateEdition(Edition edition);

    /**
     * utiliser le dao correspondant
     */
    int deleteEdition(@Param("id") UUID id);

    List<Edition> getListEditionByAlbum(@Param("id") UUID idAlbum, @Param("stock") Boolean stock);

    int cleanEditionsAlbum(@Param("IdAlbum") UUID idAlbum, @Param("editions") Collection<Edition> editions);
}
