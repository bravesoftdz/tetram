package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.dao.ValeurListeDao;

/**
 * Created by Thierry on 24/05/2014.
 */
public class CouvertureLite extends ImageLite {

    public CouvertureLite() {
        ValeurListeDao valeurListeDao = Database.getInstance().getApplicationContext().getBean(ValeurListeDao.class);
        setCategorie(valeurListeDao.getDefaultTypeCouverture());
    }

}
