/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AlbumMapper.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
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

    List<AlbumLite> getListAlbumLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<InitialeEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);

    List<AlbumLite> getListAlbumLiteBySerie(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialeEntity<Year>> getInitialesAnnees(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByAnnee(@Param("annee") Year anneeParution, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesEditeurs(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByEditeur(@Param("idEditeur") UUID idEditeur, @Param("filtre") String filtre);

    List<InitialeEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesGenres(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByGenre(@Param("idGenre") UUID idGenre, @Param("filtre") String filtre);

    List<InitialeEntity<UUID>> getInitialesCollections(@Param("filtre") String filtre);

    /*
     TODO: modifier la procédure stockée pour qu'elle utilise la vue VW_LISTE_COLLECTIONS_ALBUMS
           ou qu'elle teste id_collection sur la table COLLECTIONS par un left join
    */
    List<AlbumLite> getAlbumLiteByCollection(@Param("idCollection") UUID idCollection, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchAlbumLiteBySerie(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<Year, AlbumLite>> searchAlbumLiteByAnnee(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchAlbumLiteByCollection(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchAlbumLiteByEditeur(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<UUID, AlbumLite>> searchAlbumLiteByGenre(@Param("value") String value, @Param("filtre") String filtre);

    List<InitialeWithEntity<Character, AlbumLite>> searchAlbumLiteByInitiale(@Param("value") String value, @Param("filtre") String filtre);
}
