package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.net.URL;
import java.util.UUID;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Univers extends AbstractDBEntity {
    private String nomUnivers;
    private URL siteWeb;
    private String description;
    private UniversLite universParent;

    public String getNomUnivers() {
        return BeanUtils.trimOrNull(nomUnivers);
    }

    public void setNomUnivers(String nomUnivers) {
        this.nomUnivers = BeanUtils.trimOrNull(nomUnivers);
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public String getDescription() {
        return BeanUtils.trimOrNull(description);
    }

    public void setDescription(String description) {
        this.description = BeanUtils.trimOrNull(description);
    }

    public UniversLite getUniversParent() {
        return universParent;
    }

    public void setUniversParent(UniversLite universParent) {
        this.universParent = universParent;
    }

    public UUID getIdUniversParent() {
        return getUniversParent() == null ? null : getUniversParent().getId();
    }

}
