package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractPersonne;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 6)
public class Personne extends AbstractPersonne {

    private final StringProperty biographie = new SimpleStringProperty(this, "biographie", null);
    private final ListProperty<Serie> series = new SimpleListProperty<>(this, "series", FXCollections.observableList(new ArrayList<>()));

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
