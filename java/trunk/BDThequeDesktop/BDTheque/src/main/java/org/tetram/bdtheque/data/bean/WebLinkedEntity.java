package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;

import java.net.URL;

/**
 * Created by Thierry on 08/07/2014.
 */
public interface WebLinkedEntity {
    URL getSiteWeb();

    void setSiteWeb(URL siteWeb);

    ObjectProperty<URL> siteWebProperty();
}
