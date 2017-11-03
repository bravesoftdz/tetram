/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ValeurListeMapper.java
 * Last modified by Tetram, on 2014-07-31T14:24:23CEST
 */

package org.tetram.bdtheque.data.dao.mappers;

import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.utils.FileLink;

import java.util.List;
import java.util.Map;

/**
 * Created by Thierry on 28/05/2014.
 */
@FileLink("/org/tetram/bdtheque/data/dao/mappers/ValeurListeMapper.xml")
public interface ValeurListeMapper extends BaseMapperInterface {
    @MapKey("categorie")
    Map<CategorieValeurListe, DefaultValeurListe> getListDefaultValeur();

    List<ValeurListe> getListValeurListe(@Param("categorie") CategorieValeurListe categorie);
}
