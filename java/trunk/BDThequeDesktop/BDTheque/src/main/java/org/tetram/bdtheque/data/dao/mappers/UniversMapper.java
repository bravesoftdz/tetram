package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Univers;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.Collection;
import java.util.Set;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface UniversMapper extends BaseMapperInterface {
    UniversLite getUniversLiteById(UUID id);

    Set<UniversLite> getListUniversLiteByParaBDId(UUID id);

    Set<UniversLite> getListUniversLiteByAlbumId(UUID id);

    Set<UniversLite> getListUniversLiteBySerieId(UUID id);

    Univers getUniversById(UUID id);

    int cleanUniversAlbum(@Param("idAlbum") UUID isAlbum, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversAlbum(@Param("idAlbum") UUID isAlbum, @Param("idUnivers") UUID isUnivers);

    int cleanUniversSerie(@Param("idSerie") UUID isSerie, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversSerie(@Param("idSerie") UUID isSerie, @Param("idUnivers") UUID isUnivers);

    int cleanUniversParaBD(@Param("idParaBD") UUID isParaBD, @Param("univers") Collection<UniversLite> universToKeep);

    int addUniversParaBD(@Param("idParaBD") UUID isParaBD, @Param("idUnivers") UUID isUnivers);
}
