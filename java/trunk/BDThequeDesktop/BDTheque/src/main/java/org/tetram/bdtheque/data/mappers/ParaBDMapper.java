package org.tetram.bdtheque.data.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.ParaBD;
import org.tetram.bdtheque.data.bean.ParaBDLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 25/05/2014.
 */
public interface ParaBDMapper {
    ParaBDLite getParaBDLiteById(UUID id);

    ParaBD getParaBDById(UUID id);

    List<ParaBDLite> getParaBDLiteBySerieIdByAuteurId(@Param("idSerie") UUID idSerie, @Param("idAuteur") UUID idAuteur);
}
