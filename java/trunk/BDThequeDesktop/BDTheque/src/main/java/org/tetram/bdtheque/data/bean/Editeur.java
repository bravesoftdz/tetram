package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.net.URL;

/**
 * Created by Thierry on 24/05/2014.
 */
@DaoScriptImpl.ScriptInfo(typeData = 3)
public class Editeur extends AbstractScriptEntity {

    private String nomEditeur;
    private URL siteWeb;

    public String getNomEditeur() {
        return BeanUtils.trimOrNull(nomEditeur);
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = BeanUtils.trimOrNull(nomEditeur);
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomEditeur());
    }
}
