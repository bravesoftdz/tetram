package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.net.URL;

/**
 * Created by Thierry on 24/05/2014.
 */
@DaoScriptImpl.ScriptInfo(typeData = 3)
public class Editeur extends AbstractScriptEntity implements WebLinkedEntity {

    private String nomEditeur;
    private ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);

    public String getNomEditeur() {
        return BeanUtils.trimOrNull(nomEditeur);
    }

    public void setNomEditeur(String nomEditeur) {
        this.nomEditeur = BeanUtils.trimOrNull(nomEditeur);
    }

    @Override
    public URL getSiteWeb() {
        return siteWeb.get();
    }

    @Override
    public void setSiteWeb(URL siteWeb) {
        this.siteWeb.set(siteWeb);
    }

    @Override
    public ObjectProperty<URL> siteWebProperty() {
        return null;
    }

    @Override
    public String buildLabel() {
        return BeanUtils.formatTitre(getNomEditeur());
    }
}
