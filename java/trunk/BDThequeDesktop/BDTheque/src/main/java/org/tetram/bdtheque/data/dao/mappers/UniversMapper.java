/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UniversMapper.java
 * Last modified by Tetram, on 2014-07-31T14:24:20CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.UniversLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/UniversMapper.xml")
public interface UniversMapper extends BaseMapperInterface {
    UniversLite getUniversLiteById(@Param("id") UUID id);

    Set<UniversLite> getListUniversLiteByParaBDId(@Param("id") UUID id);

    Set<UniversLite> getListUniversLiteByAlbumId(@Param("id") UUID id);

    Set<UniversLite> getListUniversLiteBySerieId(@Param("id") UUID id);

    Univers getUniversById(@Param("id") UUID id);

    int cleanUniversAlbum(@Param("idAlbum") UUID idAlbum, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversAlbum(@Param("idAlbum") UUID idAlbum, @Param("idUnivers") UUID idUnivers);

    int cleanUniversSerie(@Param("idSerie") UUID idSerie, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversSerie(@Param("idSerie") UUID idSerie, @Param("idUnivers") UUID idUnivers);

    int cleanUniversParaBD(@Param("idParaBD") UUID idParaBD, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversParaBD(@Param("idParaBD") UUID idParaBD, @Param("idUnivers") UUID idUnivers);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<UniversLite> getUniversLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    // TODO
    List<InitialeWithEntity<Character, UniversLite>> searchUniversLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
