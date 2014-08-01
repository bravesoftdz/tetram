/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * UniversMapper.java
 * Last modified by Tetram, on 2014-08-01T12:29:10CEST
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
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/UniversMapper.xml")
public interface UniversMapper extends BaseMapperInterface {
    UniversLite getUniversLiteById(@Param("id") UUID id);

    List<UniversLite> getListUniversLiteByParaBD(@Param("id") UUID idParaBD);

    List<UniversLite> getListUniversLiteByAlbum(@Param("id") UUID idAlbum);

    List<UniversLite> getListUniversLiteBySerie(@Param("id") UUID idSerie);

    Univers getUniversById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    UUID checkUniqueUnivers(Univers univers);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int createUnivers(Univers univers);

    /**
     * ne surtout pas mettre @Param
     *
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int updateUnivers(Univers univers);

    /**
     * @deprecated utiliser le dao correspondant
     */
    @Deprecated
    int deleteUnivers(UUID id);

    int cleanUniversAlbum(@Param("idAlbum") UUID idAlbum, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversAlbum(@Param("idAlbum") UUID idAlbum, @Param("idUnivers") UUID idUnivers);

    int cleanUniversSerie(@Param("idSerie") UUID idSerie, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversSerie(@Param("idSerie") UUID idSerie, @Param("idUnivers") UUID idUnivers);

    int cleanUniversParaBD(@Param("idParaBD") UUID idParaBD, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversParaBD(@Param("idParaBD") UUID idParaBD, @Param("idUnivers") UUID idUnivers);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<UniversLite> getListUniversLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, UniversLite>> searchListUniversLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
