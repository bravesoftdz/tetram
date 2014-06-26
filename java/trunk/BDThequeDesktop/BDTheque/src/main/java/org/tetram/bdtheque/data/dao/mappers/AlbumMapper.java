package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.gui.utils.InitialEntity;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
public interface AlbumMapper extends BaseMapperInterface {
    AlbumLite getAlbumLiteById(@Param("id") UUID id, @Param("idEdition") UUID idEdition);

    Album getAlbumById(@Param("id") UUID id);

    List<AlbumLite> getAlbumLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);

    int acheter(@Param("id") UUID id, @Param("achat") boolean previsionAchat);

    List<InitialEntity<UUID>> getInitialesSeries(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteBySerie(@Param("idSerie") UUID idSerie, @Param("filtre") String filtre);

    List<InitialEntity<Integer>> getInitialesAnnees(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByAnnee(@Param("annee") Integer anneeParution, @Param("filtre") String filtre);

    List<InitialEntity<UUID>> getInitialesEditeurs(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByEditeur(@Param("idEditeur") UUID idEditeur, @Param("filtre") String filtre);

    List<InitialEntity<Character>> getInitiales(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByInitiale(@Param("initiale") Character initiale, @Param("filtre") String filtre);

    List<InitialEntity<UUID>> getInitialesGenres(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByGenre(@Param("idGenre") UUID idGenre, @Param("filtre") String filtre);

    List<InitialEntity<UUID>> getInitialesCollections(@Param("filtre") String filtre);

    List<AlbumLite> getAlbumLiteByCollection(@Param("idCollection") UUID idCollection, @Param("filtre") String filtre);
}
