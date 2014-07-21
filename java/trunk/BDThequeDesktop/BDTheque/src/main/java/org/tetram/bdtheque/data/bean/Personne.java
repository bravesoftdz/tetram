package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.bean.abstractentities.BasePersonne;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Thierry on 24/05/2014.
 */

@DaoScriptImpl.ScriptInfo(typeData = 6)
public class Personne extends BasePersonne implements ScriptEntity {

    private final StringProperty biographie = new AutoTrimStringProperty(this, "biographie", null);
    private final ListProperty<Serie> series = new SimpleListProperty<>(this, "series", FXCollections.observableList(new ArrayList<>()));
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    public String getBiographie() {
        return biographie.get();
    }

    public void setBiographie(String biographie) {
        this.biographie.set(biographie);
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

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

}
