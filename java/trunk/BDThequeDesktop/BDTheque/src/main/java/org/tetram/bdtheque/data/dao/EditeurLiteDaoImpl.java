package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
@Repository
@Lazy
@Transactional

public class EditeurLiteDaoImpl extends DaoROImpl<EditeurLite, UUID> implements EditeurLiteDao {
    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        // TODO
        return null;
    }

    @Override
    public List<EditeurLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        // TODO
        return null;
    }

    @Override
    public List<InitialeWithEntity<Character, EditeurLite>> searchList(@Param("value") String value, @Param("filtre") String filtre) {
        // TODO
        return null;
    }

}
