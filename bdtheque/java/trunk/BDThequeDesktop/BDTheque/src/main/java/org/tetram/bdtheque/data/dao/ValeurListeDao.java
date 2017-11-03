/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * ValeurListeDao.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;

import java.util.List;

/**
 * Created by Thierry on 10/06/2014.
 */
public interface ValeurListeDao {
    ValeurListe getDefaultEtat();

    ValeurListe getDefaultReliure();

    ValeurListe getDefaultTypeEdition();

    ValeurListe getDefaultOrientation();

    ValeurListe getDefaultFormatEdition();

    ValeurListe getDefaultTypeCouverture();

    ValeurListe getDefaultTypeParaBD();

    ValeurListe getDefaultSensLecture();

    ValeurListe getDefaultNotation();

    ValeurListe getDefaultTypePhoto();

    List<ValeurListe> getListValeurListe(CategorieValeurListe categorie);
}
