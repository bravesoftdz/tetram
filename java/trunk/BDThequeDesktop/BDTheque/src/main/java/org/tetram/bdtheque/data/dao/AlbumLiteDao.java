package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.AlbumLite;

import java.util.UUID;

/**
 * Created by Thierry on 23/06/2014.
 */
public interface AlbumLiteDao<InitialeValueType> extends DaoRO<AlbumLite, UUID>, RepertoireLiteDao<AlbumLite, InitialeValueType> {

}
