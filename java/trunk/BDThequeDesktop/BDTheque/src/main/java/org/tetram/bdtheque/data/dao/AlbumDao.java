package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.Album;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface AlbumDao extends DaoRW<Album, UUID> {
    void fusionneInto(@NotNull Album source, @NotNull Album dest);
}
