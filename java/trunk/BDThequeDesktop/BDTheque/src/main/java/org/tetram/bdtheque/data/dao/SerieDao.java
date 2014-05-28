package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.lite.SerieLite;

import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface SerieDao {
    SerieLite getSerieLiteById(UUID id);

    Serie getSerieById(UUID id);
}
