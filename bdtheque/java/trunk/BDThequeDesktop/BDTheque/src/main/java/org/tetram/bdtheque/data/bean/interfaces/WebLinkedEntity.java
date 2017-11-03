/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * WebLinkedEntity.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ObjectProperty;

import java.net.URL;

/**
 * Created by Thierry on 08/07/2014.
 */

public interface WebLinkedEntity extends DBEntity {
    default URL getSiteWeb() {
        return siteWebProperty().get();
    }

    default void setSiteWeb(URL siteWeb) {
        siteWebProperty().set(siteWeb);
    }

    ObjectProperty<URL> siteWebProperty();
}
