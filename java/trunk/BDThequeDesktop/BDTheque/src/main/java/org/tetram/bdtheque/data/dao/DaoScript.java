package org.tetram.bdtheque.data.dao;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.data.bean.AbstractScriptEntity;

/**
 * Created by Thierry on 12/06/2014.
 */
public interface DaoScript<T extends AbstractScriptEntity> {
    void fillAssociations(@NotNull T entity);

    void saveAssociations(@NotNull T entity);
}
