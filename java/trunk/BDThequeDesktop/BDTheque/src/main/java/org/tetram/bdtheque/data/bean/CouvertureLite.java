package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.abstractentities.BaseImage;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

/**
 * Created by Thierry on 24/05/2014.
 */
public class CouvertureLite extends BaseImage {

    static {
        baseClass = CouvertureLite.class;
    }

    public CouvertureLite() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setCategorie(valeurListeDao.getDefaultTypeCouverture());
    }

}
