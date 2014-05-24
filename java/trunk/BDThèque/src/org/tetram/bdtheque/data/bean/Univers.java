package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.UniversLite;

import java.net.URL;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Univers extends DBEntity {
    private String nomUnivers;
    private URL siteWeb;
    private String description;
    private UniversLite universParent;

    public String getNomUnivers() {
        return nomUnivers;
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers = nomUnivers;
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public UniversLite getUniversParent() {
        return universParent;
    }

    public void setUniversParent(UniversLite universParent) {
        this.universParent = universParent;
    }

    public UUID getIdUniversParent() {
        return universParent.getId();
    }

}
