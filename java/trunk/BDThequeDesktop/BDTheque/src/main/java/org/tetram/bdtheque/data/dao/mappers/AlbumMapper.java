package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.data.bean.ValeurListe;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
public interface AlbumMapper extends BaseMapperInterface {
    AlbumLite getAlbumLiteById(@Param("id") UUID id, @Param("idEdition") UUID idEdition);

    Album getAlbumById(UUID id);

    List<AlbumLite> getAlbumLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);

    int changeNotation(@Param("id") UUID id, @Param("notation") ValeurListe note);
}
