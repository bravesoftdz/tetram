package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Auteur extends AbstractScriptEntity {
    private String nomAuteur;
    private URL siteWeb;
    private String biographie;
    private List<Serie> series = new ArrayList<>();

    public String getNomAuteur() {
        return BeanUtils.trim(nomAuteur);
    }

    public void setNomAuteur(String nomAuteur) {
        this.nomAuteur = BeanUtils.trim(nomAuteur);
    }

    public URL getSiteWeb() {
        return siteWeb;
    }

    public void setSiteWeb(URL siteWeb) {
        this.siteWeb = siteWeb;
    }

    public String getBiographie() {
        return BeanUtils.trim(biographie);
    }

    public void setBiographie(String biographie) {
        this.biographie = BeanUtils.trim(biographie);
    }

    public List<Serie> getSeries() {
        return series;
    }

    public void setSeries(List<Serie> idSeries) {
        this.series = idSeries;
    }

}
