package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.gui.utils.InitialeEntity;

import java.util.List;

/**
 * Created by Thierry on 23/06/2014.
 */
public interface RepertoireLiteDao<T extends AbstractDBEntity, InitialeValueType> {
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

    List<AlbumLite> getListEntitiesByInitiale(InitialeEntity<InitialeValueType> initiale, String filtre);

}
