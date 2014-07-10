package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.abstractentities.AbstractImage;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;

/**
 * Created by Thierry on 24/05/2014.
 */
public class CouvertureLite extends AbstractImage {

    public CouvertureLite() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setCategorie(valeurListeDao.getDefaultTypeCouverture());
    }

}
