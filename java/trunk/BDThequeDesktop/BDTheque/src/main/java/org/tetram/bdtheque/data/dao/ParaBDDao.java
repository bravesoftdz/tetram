package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.lite.ParaBDLite;

import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface ParaBDDao {
    ParaBDLite getParaBDLiteById(UUID id);

    ParaBD getParaBDById(UUID id);
}
