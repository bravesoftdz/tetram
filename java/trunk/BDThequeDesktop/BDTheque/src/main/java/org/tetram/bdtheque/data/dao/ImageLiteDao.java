/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ImageLiteDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.abstractentities.BaseImage;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.spring.SpringContext;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
public interface ImageLiteDao<T extends BaseImage, K> extends DaoRW<T, K> {

    byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing, boolean cadre, int effet3D);

    default byte[] getImageStream(T image, Integer height, Integer width, boolean antiAliasing) {
        return getImageStream(image, height, width, antiAliasing, false, 0);
    }

    default byte[] getImageStream(T image, Integer height, Integer width) {
        return getImageStream(image, height, width, SpringContext.CONTEXT.getBean(UserPreferences.class).isAntiAliasing());
    }

    void saveList(List<T> list, UUID parentId, Map<String, UUID> secondaryParams);

    default void saveList(List<T> list, UUID parentId) {
        saveList(list, parentId, null);
    }
}
