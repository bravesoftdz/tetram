package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 6)
public class Personne extends AbstractScriptEntity implements WebLinkedEntity {

    private StringProperty nomPersonne = new SimpleStringProperty(this, "nomPersonne", null);
    private ObjectProperty<URL> siteWeb = new SimpleObjectProperty<>(this, "siteWeb", null);
    private StringProperty biographie = new SimpleStringProperty(this, "biographie", null);
    private ListProperty<Serie> series = new SimpleListProperty<>(this, "series", FXCollections.observableList(new ArrayList<>()));

    public String getNomPersonne() {
        return BeanUtils.trimOrNull(nomPersonne.get());
    }

    public void setNomPersonne(String nomPersonne) {
        this.nomPersonne.set(BeanUtils.trimOrNull(nomPersonne));
    }

    public StringProperty nomPersonneProperty() {
        return nomPersonne;
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
        return siteWeb;
    }

    public String getBiographie() {
        return BeanUtils.trimOrNull(biographie.get());
    }

    public void setBiographie(String biographie) {
        this.biographie.set(BeanUtils.trimOrNull(biographie));
    }

    public StringProperty biographieProperty() {
        return biographie;
    }

    public List<Serie> getSeries() {
        return series;
    }

    public void setSeries(List<Serie> series) {
        this.series.set(FXCollections.observableList(series));
    }

    public ListProperty<Serie> seriesProperty() {
        return series;
    }

}
