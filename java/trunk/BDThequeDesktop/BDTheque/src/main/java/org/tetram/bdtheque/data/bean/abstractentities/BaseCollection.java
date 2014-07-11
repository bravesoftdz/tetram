package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;
import java.util.UUID;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class BaseCollection<E extends BaseEditeur> extends AbstractDBEntity {
    public static Comparator<CollectionLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomCollection(), o2.getNomCollection());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomCollection = new AutoTrimStringProperty(this, "nomCollection", null);
    private final ObjectProperty<E> editeur = new SimpleObjectProperty<>(this, "editeur", null);

    static {
        baseClass = BaseCollection.class;
    }

    public String getNomCollection() {
        return nomCollection.get();
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.set(nomCollection);
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    public E getEditeur() {
        return editeur.get();
    }

    public void setEditeur(E editeur) {
        this.editeur.set(editeur);
    }

    public ObjectProperty<E> editeurProperty() {
        return editeur;
    }

    public UUID getIdEditeur() {
        return getEditeur() == null ? null : getEditeur().getId();
    }

    @Override
    public String toString() {
        return buildLabel(false);
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public String buildLabel(boolean simple) {
        String lb = BeanUtils.formatTitre(getNomCollection());
        if (!simple && getEditeur() != null)
            lb = StringUtils.ajoutString(lb, getEditeur().buildLabel(), " ", "(", ")");
        return lb;
    }
}
