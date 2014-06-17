package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.ImageLite;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
public interface ImageLiteDao<T extends ImageLite, K> extends DaoRW<T, K> {
    byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing, boolean cadre, int effet3D);

    default byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing) {
        return getImageStream(image, height, width, antiAliasing, false, 0);
    }

    void saveList(List<T> list, UUID parentId, Map<String, UUID> secondaryParams);

    default void saveList(List<T> list, UUID parentId) {
        saveList(list, parentId, null);
    }
}
