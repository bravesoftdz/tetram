/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BaseGenre.java
 * Last modified by Thierry, on 2014-08-06T11:05:31CEST
 */

package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.Comparator;

/**
 * Created by Thierry on 06/08/2014.
 */
public abstract class BaseGenre extends AbstractDBEntity {
    public static Comparator<BaseGenre> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomGenre(), o2.getNomGenre());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomGenre = new AutoTrimStringProperty(this, "nomGenre", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseGenre.class;
    }

    public String getNomGenre() {
        return nomGenre.get();
    }

    public void setNomGenre(String nomGenre) {
        this.nomGenre.set(nomGenre);
    }

    public StringProperty nomGenreProperty() {
        return nomGenre;
    }

    @Override
    public String buildLabel() {
        return getNomGenre();
    }
}
