package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.Comparator;

/**
 * Created by Thierry on 10/07/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public abstract class AbstractCollection extends AbstractScriptEntity {
    public static Comparator<CollectionLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomCollection(), o2.getNomCollection());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty nomCollection = new AutoTrimStringProperty(this, "nomCollection", null);

    public String getNomCollection() {
        return nomCollection.get();
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.set(nomCollection);
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    @Override
    public String toString() {
        return buildLabel(false);
    }

    @Override
    public String buildLabel() {
        return buildLabel(true);
    }

    public abstract String buildLabel(boolean simple);
}
