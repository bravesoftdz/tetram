package org.tetram.bdtheque.data.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.AlbumLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
public interface AlbumMapper {
    AlbumLite getAlbumLiteById(@Param("id") UUID id, @Param("idEdition") UUID idEdition);

    Album getAlbumById(UUID id);

    List<AlbumLite> getAlbumLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);
}
