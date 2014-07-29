/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * PhotoLiteDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.PhotoLite;

import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
@Transactional

public class PhotoLiteDaoImpl extends ImageLiteDaoImpl<PhotoLite, UUID> implements PhotoLiteDao {

    public PhotoLiteDaoImpl() {
        super(
                "photos",
                "id_photo",
                "id_parabd",
                "fichierPhoto",
                "stockagePhoto",
                "imagePhoto"
        );
    }

}
