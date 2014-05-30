package org.tetram.bdtheque.data.dao;

import org.apache.ibatis.session.SqlSession;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

/**
 * Created by Thierry on 30/05/2014.
 */
public class SerieDao extends AbstractDao<Serie, UUID> {

    @Override
    public Serie get(UUID id, SqlSession session) {
        if (id == null || id.equals(StringUtils.GUID_NULL))
            return new Serie();
        else
            return super.get(id, session);
    }

}
