package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.AlbumLite;
import org.tetram.bdtheque.gui.utils.InitialEntity;

import java.util.List;

/**
 * Created by Thierry on 23/06/2014.
 */
public interface RepertoireLiteDao<T extends AbstractDBEntity, InitialeValueType> {
    default List<InitialEntity<InitialeValueType>> getInitiales(String filtre) {
        final List<InitialEntity<InitialeValueType>> list = getListInitiales(filtre);
        if (list != null)
            for (InitialEntity initialEntity : list) {
                if (initialEntity.getValue() == null)
                    initialEntity.setLabel(getUnknownLabel());
                initialEntity.setLabel(BeanUtils.formatTitre(initialEntity.getLabel()));
            }
        return list;
    }

    List<InitialEntity<InitialeValueType>> getListInitiales(String filtre);

    default String getUnknownLabel() {
        return null;
    }

    List<AlbumLite> getListEntitiesByInitiale(InitialEntity<InitialeValueType> initiale, String filtre);

}
