package org.tetram.bdtheque.data.bean;

import java.net.URL;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Editeur extends DBEntity {
    private String nomEditeur;
    private URL siteWeb;

    public String getNomEditeur() {
        return nomEditeur.trim();
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = nomEditeur.trim();
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

}
