package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.UUID;

/**
 * Created by Thierry on 12/06/2014.
 */
public interface UniversLiteDao extends DaoRO<UniversLite, UUID>, RepertoireLiteDao<UniversLite, Character> {
}
