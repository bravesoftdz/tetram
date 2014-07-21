package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.*;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */

public abstract class BaseImage extends AbstractDBEntity {

    public static Comparator<BaseImage> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = ValeurListe.DEFAULT_COMPARATOR.compare(o1.getCategorie(), o2.getCategorie());
        if (comparaison != 0) return comparaison;

        comparaison = BeanUtils.compare(o1.getPosition(), o2.getPosition());
        if (comparaison != 0) return comparaison;

        return 0;
    };

    private final StringProperty oldNom = new AutoTrimStringProperty(this, "oldNom", null);
    private final StringProperty newNom = new AutoTrimStringProperty(this, "newNom", null);
    private final BooleanProperty oldStockee = new SimpleBooleanProperty(this, "oldStockee", false);
    private final BooleanProperty newStockee = new SimpleBooleanProperty(this, "newStockee", false);
    private final ObjectProperty<ValeurListe> categorie = new SimpleObjectProperty<>(this, "categorie", null);
    private final IntegerProperty position = new SimpleIntegerProperty(this, "position", 0);

    public String getOldNom() {
        return oldNom.get();
    }

    public void setOldNom(String oldNom) {
        this.oldNom.set(oldNom);
    }

    public StringProperty oldNomProperty() {
        return oldNom;
    }

    public String getNewNom() {
        return newNom.get();
    }

    public void setNewNom(String newNom) {
        this.newNom.set(newNom);
    }

    public StringProperty newNomProperty() {
        return newNom;
    }

    public boolean isOldStockee() {
        return oldStockee.get();
    }

    public void setOldStockee(boolean oldStockee) {
        this.oldStockee.set(oldStockee);
    }

    public BooleanProperty oldStockeeProperty() {
        return oldStockee;
    }

    public boolean isNewStockee() {
        return newStockee.get();
    }

    public void setNewStockee(boolean newStockee) {
        this.newStockee.set(newStockee);
    }

    public BooleanProperty newStockeeProperty() {
        return newStockee;
    }

    public ValeurListe getCategorie() {
        return categorie.get();
    }

    public void setCategorie(ValeurListe categorie) {
        this.categorie.set(categorie);
    }

    public ObjectProperty<ValeurListe> categorieProperty() {
        return categorie;
    }

    public int getPosition() {
        return position.get();
    }

    public void setPosition(int position) {
        this.position.set(position);
    }

    public IntegerProperty positionProperty() {
        return position;
    }

    @Override
    public String buildLabel() {
        return getNewNom();
    }

}
