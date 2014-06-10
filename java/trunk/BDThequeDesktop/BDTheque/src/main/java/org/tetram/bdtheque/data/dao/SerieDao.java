package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.Serie;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface SerieDao extends Dao<Serie, UUID> {
    @Override
    Serie get(UUID id);
}
