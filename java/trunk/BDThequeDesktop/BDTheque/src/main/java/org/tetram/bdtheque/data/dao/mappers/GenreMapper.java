package org.tetram.bdtheque.data.dao.mappers;

import org.tetram.bdtheque.data.bean.GenreLite;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 02/06/2014.
 */
public interface GenreMapper extends BaseMapperInterface {
    GenreLite getGenreLiteById(UUID id);

    List<GenreLite> getListGenreBySerieId(UUID id);

    int createGenreLite(GenreLite genre);

    int updateGenreLite(GenreLite genre);

    int deleteGenreLite(UUID id);
}
