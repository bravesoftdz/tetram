/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EditeurMapper.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.Editeur;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.utils.FileLink;

import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/Editeur.xml")
public interface EditeurMapper extends BaseMapperInterface {
    EditeurLite getEditeurLiteById(@Param("id") UUID id);

    Editeur getEditeurById(@Param("id") UUID id);
}
