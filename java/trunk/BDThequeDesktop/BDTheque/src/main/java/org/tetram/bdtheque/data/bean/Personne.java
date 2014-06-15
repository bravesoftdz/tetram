package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 24/05/2014.
 */
@DaoScriptImpl.ScriptInfo(typeData = 6)
public class Personne extends AbstractScriptEntity {

    private String nomPersonne;
    private URL siteWeb;
    private String biographie;
    private List<Serie> series = new ArrayList<>();

    public String getNomPersonne() {
        return BeanUtils.trimOrNull(nomPersonne);
    }

    public void setNomPersonne(String nomPersonne) {
        this.nomPersonne = BeanUtils.trimOrNull(nomPersonne);
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public String getBiographie() {
        return BeanUtils.trimOrNull(biographie);
    }

    public void setBiographie(String biographie) {
        this.biographie = BeanUtils.trimOrNull(biographie);
    }

    public List<Serie> getSeries() {
        return series;
    }

    public void setSeries(List<Serie> idSeries) {
        this.series = idSeries;
    }

}
