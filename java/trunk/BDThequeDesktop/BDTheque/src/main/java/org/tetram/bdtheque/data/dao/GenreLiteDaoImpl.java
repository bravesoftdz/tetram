package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.ConsistencyException;
import org.tetram.bdtheque.data.bean.GenreLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Repository
@Lazy
@Transactional

public class GenreLiteDaoImpl extends DaoScriptImpl<GenreLite, UUID> implements GenreLiteDao {

    @Override
    public void validate(@NotNull GenreLite object) throws ConsistencyException {
        super.validate(object);
        if (StringUtils.isNullOrEmpty(object.getGenre()))
            throw new ConsistencyException(I18nSupport.message("nom.obligatoire"));
    }

    @Override
    public int save(@NotNull GenreLite o) throws ConsistencyException {
        if (!isUnique(o))
            throw new ConsistencyException(I18nSupport.message("title.still.used", I18nSupport.message("genre")));
        return super.save(o);
    }

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        // TODO
        return null;
    }

    @Override
    public List<GenreLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        // TODO
        return null;
    }
}
