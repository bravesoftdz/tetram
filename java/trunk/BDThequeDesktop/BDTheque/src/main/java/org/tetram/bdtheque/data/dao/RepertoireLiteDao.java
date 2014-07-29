/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * RepertoireLiteDao.java
 * Last modified by Tetram, on 2014-07-29T14:47:56CEST
 */

package org.tetram.bdtheque.data.dao;

import org.apache.commons.collections4.map.ListOrderedMap;
import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.InitialeEntity;
import org.tetram.bdtheque.data.bean.InitialeWithEntity;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 23/06/2014.
 */
public interface RepertoireLiteDao<T extends AbstractDBEntity, InitialeValueType extends Comparable<InitialeValueType>> {
    default List<? extends InitialeEntity<InitialeValueType>> getInitiales(String filtre) {
        final List<? extends InitialeEntity<InitialeValueType>> list = getListInitiales(filtre);
        if (list != null)
            for (InitialeEntity initialeEntity : list) {
                if (initialeEntity.getValue() == null)
                    initialeEntity.setLabel(getUnknownLabel());
                initialeEntity.setLabel(BeanUtils.formatTitre(initialeEntity.getLabel()));
            }
        return list;
    }

    List<? extends InitialeEntity<InitialeValueType>> getListInitiales(String filtre);

    default String getUnknownLabel() {
        return null;
    }

    List<T> getListEntitiesByInitiale(InitialeEntity<InitialeValueType> initiale, String filtre);

    List<InitialeWithEntity<InitialeValueType, T>> searchList(@Param("value") String value, @Param("filtre") String filtre);

    default ListOrderedMap<InitialeEntity<InitialeValueType>, List<T>> searchMap(String value, String filtre) {
        ListOrderedMap<InitialeEntity<InitialeValueType>, List<T>> m = new ListOrderedMap<>();
        List<InitialeWithEntity<InitialeValueType, T>> entities = searchList(value, filtre);
        entities.forEach(i -> {
            List<T> list = m.get(i.getInitiale());
            if (list == null) list = new ArrayList<>();
            list.add(i.getEntity());
            m.put(i.getInitiale(), list);
        });
        return m;
    }

}
