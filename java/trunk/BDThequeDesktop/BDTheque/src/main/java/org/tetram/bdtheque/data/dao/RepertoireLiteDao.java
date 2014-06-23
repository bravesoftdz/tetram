package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.gui.utils.InitialEntity;

import java.util.List;

/**
 * Created by Thierry on 23/06/2014.
 */
public interface RepertoireLiteDao<T extends AbstractDBEntity> {
    List<InitialEntity> getListInitiales();
}
