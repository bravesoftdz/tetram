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

    byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing);

    void saveList(List<T> list, UUID parentId, Map<String, UUID> secondaryParams);
}
