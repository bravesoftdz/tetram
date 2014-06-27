package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ParaBDLite;

import java.util.UUID;

/**
 * Created by Thierry on 27/06/2014.
 */
public interface ParaBDLiteDao extends DaoRO<ParaBDLite, UUID>, RepertoireLiteDao<ParaBDLite, UUID> {
}
