package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.net.URL;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Editeur extends AbstractScriptEntity {
    private String nomEditeur;
    private URL siteWeb;

    public String getNomEditeur() {
        return BeanUtils.trim(nomEditeur);
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = BeanUtils.trim(nomEditeur);
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

}
