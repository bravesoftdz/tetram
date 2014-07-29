/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * EntityNotFoundException.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.gui.utils;

import org.tetram.bdtheque.utils.I18nSupport;

/**
 * Created by Thierry on 30/06/2014.
 */
public class EntityNotFoundException extends RuntimeException {
    public EntityNotFoundException() {
        this(I18nSupport.message("impossible.de.trouver.l.entite.dans.la.base.de.donnees"));
    }

    public EntityNotFoundException(String message) {
        super(message);
    }
}
