/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * CouvertureLiteDaoImpl.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.CouvertureLite;

import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
@Transactional

public class CouvertureLiteDaoImpl extends ImageLiteDaoImpl<CouvertureLite, UUID> implements CouvertureLiteDao {

    public CouvertureLiteDaoImpl() {
        super(
                "couvertures",
                "id_couverture",
                "id_edition",
                "fichierCouverture",
                "stockageCouverture",
                "imageCouverture"
        );
    }

}
