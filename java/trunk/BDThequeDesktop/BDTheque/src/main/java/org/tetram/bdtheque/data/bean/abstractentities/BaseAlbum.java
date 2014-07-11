package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.Album;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.bean.interfaces.EvaluatedEntity;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.TypeUtils;

import java.time.Month;
import java.time.Year;
import java.util.Comparator;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class BaseAlbum extends AbstractDBEntity implements EvaluatedEntity {
    public static Comparator<Album> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        // horsSerie nulls first
        comparaison = BeanUtils.compare(o1.isHorsSerie(), o2.isHorsSerie());
        if (comparaison != 0) return comparaison;

        // integrale nulls first
        comparaison = BeanUtils.compare(o1.isIntegrale(), o2.isIntegrale());
        if (comparaison != 0) return comparaison;

        // tome nulls first
        comparaison = BeanUtils.compare(o1.getTome(), o2.getTome());
        if (comparaison != 0) return comparaison;

        // anneeParution nulls first
        comparaison = BeanUtils.compare(o1.getAnneeParution(), o2.getAnneeParution());
        if (comparaison != 0) return comparaison;

        // moisParution nulls first
        comparaison = BeanUtils.compare(o1.getMoisParution(), o2.getMoisParution());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty titreAlbum = new AutoTrimStringProperty(this, "titreAlbum", null);
    private final ObjectProperty<Month> moisParution = new SimpleObjectProperty<>(this, "moisParution", null);
    private final ObjectProperty<Year> anneeParution = new SimpleObjectProperty<>(this, "anneeParution", null);
    private final BooleanProperty complet = new SimpleBooleanProperty(this, "complet", false);
    private final ObjectProperty<Integer> tome = new SimpleObjectProperty<>(this, "tome", null);
    private final ObjectProperty<Integer> tomeDebut = new SimpleObjectProperty<>(this, "tomeDebut", null);
    private final ObjectProperty<Integer> tomeFin = new SimpleObjectProperty<>(this, "tomeFin", null);
    private final BooleanProperty horsSerie = new SimpleBooleanProperty(this, "horsSerie", false);
    private final BooleanProperty integrale = new SimpleBooleanProperty(this, "integrale", false);
    private final ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseAlbum.class;
    }

    protected BaseAlbum() {
        ValeurListeDao valeurListeDao = SpringContext.CONTEXT.getBean(ValeurListeDao.class);
        setNotation(valeurListeDao.getDefaultNotation());
        anneeParutionProperty().addListener((observable, oldValue, newValue) -> {
            if (TypeUtils.isNullOrZero(getAnneeParution()))
                setMoisParution(null);
        });
    }

    public boolean isComplet() {
        return complet.get();
    }

    public void setComplet(boolean complet) {
        this.complet.set(complet);
    }

    public BooleanProperty completProperty() {
        return complet;
    }

    public String getTitreAlbum() {
        return titreAlbum.get();
    }

    public void setTitreAlbum(String titreAlbum) {
        this.titreAlbum.set(titreAlbum);
    }

    public StringProperty titreAlbumProperty() {
        return titreAlbum;
    }

    public Month getMoisParution() {
        return TypeUtils.isNullOrZero(getAnneeParution()) ? null : moisParution.get();
    }

    public void setMoisParution(Month moisParution) {
        this.moisParution.set(moisParution);
    }

    public ObjectProperty<Month> moisParutionProperty() {
        return moisParution;
    }

    public Year getAnneeParution() {
        return anneeParution.get();
    }

    public void setAnneeParution(Year anneeParution) {
        this.anneeParution.set(anneeParution);
    }

    public ObjectProperty<Year> anneeParutionProperty() {
        return anneeParution;
    }

    public Integer getTome() {
        return tome.get();
    }

    public void setTome(Integer tome) {
        this.tome.set(tome);
    }

    public ObjectProperty<Integer> tomeProperty() {
        return tome;
    }

    public Integer getTomeDebut() {
        return tomeDebut.get();
    }

    public void setTomeDebut(Integer tomeDebut) {
        this.tomeDebut.set(tomeDebut);
    }

    public ObjectProperty<Integer> tomeDebutProperty() {
        return tomeDebut;
    }

    public Integer getTomeFin() {
        return tomeFin.get();
    }

    public void setTomeFin(Integer tomeFin) {
        this.tomeFin.set(tomeFin);
    }

    public ObjectProperty<Integer> tomeFinProperty() {
        return tomeFin;
    }

    public boolean isHorsSerie() {
        return horsSerie.get();
    }

    public void setHorsSerie(boolean horsSerie) {
        this.horsSerie.set(horsSerie);
    }

    public BooleanProperty horsSerieProperty() {
        return horsSerie;
    }

    public boolean isIntegrale() {
        return integrale.get();
    }

    public void setIntegrale(boolean integrale) {
        this.integrale.set(integrale);
    }

    public BooleanProperty integraleProperty() {
        return integrale;
    }

    @Override
    public ObjectProperty<ValeurListe> notationProperty() {
        return notation;
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean avecSerie) {
        return buildLabel(false, avecSerie);
    }

    public abstract String buildLabel(boolean simple, boolean avecSerie);
}
