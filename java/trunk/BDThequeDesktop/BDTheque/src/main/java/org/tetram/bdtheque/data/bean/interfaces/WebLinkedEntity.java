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
