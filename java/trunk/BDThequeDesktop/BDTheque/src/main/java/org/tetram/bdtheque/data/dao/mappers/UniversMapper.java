package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface UniversMapper extends BaseMapperInterface {
    UniversLite getUniversLiteById(UUID id);

    List<UniversLite> getListUniversLiteByParaBDId(UUID id);

    List<UniversLite> getListUniversLiteByAlbumId(UUID id);

    List<UniversLite> getListUniversLiteBySerieId(UUID id);

    Univers getUniversById(UUID id);
}
