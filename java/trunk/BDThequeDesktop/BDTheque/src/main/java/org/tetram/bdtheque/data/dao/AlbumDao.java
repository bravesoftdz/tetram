package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.lite.AlbumLite;

import java.util.UUID;

/**
 * Created by Thierry on 29/05/2014.
 */
public interface AlbumDao {
    AlbumLite getAlbumLiteById(@Param("id") UUID id, @Param("idEdition") UUID idEdition);

    Album getAlbumById(UUID id);
}
