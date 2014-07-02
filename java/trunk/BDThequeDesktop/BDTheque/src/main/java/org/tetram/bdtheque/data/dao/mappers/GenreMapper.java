package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.GenreLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 02/06/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Genre.xml")
public interface GenreMapper extends BaseMapperInterface {
    GenreLite getGenreLiteById(UUID id);

    List<GenreLite> getListGenreBySerieId(UUID id);

    int createGenreLite(GenreLite genre);

    int updateGenreLite(GenreLite genre);

    int deleteGenreLite(UUID id);

    int cleanGenresSerie(@Param("id") UUID idSerie);

    int addGenreSerie(@Param("idSerie") UUID idSerie, @Param("idGenre") UUID idGenre);
}


