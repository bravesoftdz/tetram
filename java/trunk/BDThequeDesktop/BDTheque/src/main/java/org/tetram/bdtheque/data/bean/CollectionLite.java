package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class CollectionLite extends AbstractDBEntity {

    public static Comparator<CollectionLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getNomCollection(), o2.getNomCollection());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private StringProperty nomCollection = new AutoTrimStringProperty(this, "nomCollection", null);
    private ObjectProperty<EditeurLite> editeur = new SimpleObjectProperty<>(this, "editeur", null);

    public String getNomCollection() {
        return nomCollection.get();
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.set(nomCollection);
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    public EditeurLite getEditeur() {
        return editeur.get();
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur.set(editeur);
    }

    public ObjectProperty<EditeurLite> editeurProperty() {
        return editeur;
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
            lb = StringUtils.ajoutString(lb, BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ", "(", ")");
        return lb;
    }

}
