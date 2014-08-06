/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumMapper.java
 * Last modified by Tetram, on 2014-08-01T12:32:46CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.*;
import org.tetram.bdtheque.utils.FileLink;

import java.time.Year;
import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/AlbumMapper.xml")
public interface AlbumMapper extends BaseMapperInterface {
    AlbumLite getAlbumLiteById(@Param("id") UUID id, @Param("idEdition") UUID idEdition);

    Album getAlbumById(@Param("id") UUID id);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int createAlbum(Album album);

    /**
     * ne surtout pas mettre @Param
     * utiliser le dao correspondant
     */
    int updateAlbum(Album album);

    /**
     * utiliser le dao correspondant
     */
    int deleteAlbum(@Param("id") UUID id);

    List<AlbumLite> getListAlbumLiteBySerieByAuteur(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<InitialeEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteBySerie(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialeEntity<Year>> getInitialesAnnees(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteByAnnee(@Param("annee") Year anneeParution, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesEditeurs(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteByEditeur(@Param("idEditeur") UUID idEditeur, @Param("filtre") String filtre);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesGenres(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteByGenre(@Param("idGenre") UUID idGenre, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesCollections(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteByCollection(@Param("idCollection") UUID idCollection, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchListAlbumLiteBySerie(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<Year, AlbumLite>> searchListAlbumLiteByAnnee(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchListAlbumLiteByCollection(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchListAlbumLiteByEditeur(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchListAlbumLiteByGenre(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, AlbumLite>> searchListAlbumLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
