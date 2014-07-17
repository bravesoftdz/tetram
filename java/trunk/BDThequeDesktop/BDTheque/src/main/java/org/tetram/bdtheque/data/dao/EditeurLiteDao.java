package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.EditeurLite;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
public interface EditeurLiteDao extends DaoRO<EditeurLite, UUID>, RepertoireLiteDao<EditeurLite, Character> {
}
