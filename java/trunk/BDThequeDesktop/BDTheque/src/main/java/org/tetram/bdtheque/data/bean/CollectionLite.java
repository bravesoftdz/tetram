package org.tetram.bdtheque.data.bean;

import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class CollectionLite extends AbstractDBEntity {

    public static Comparator<CollectionLite> DEFAULT_COMPARATOR = new Comparator<CollectionLite>() {
        @Override
        public int compare(CollectionLite o1, CollectionLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getNomCollection(), o2.getNomCollection());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private StringProperty nomCollection = new SimpleStringProperty();
    private EditeurLite editeur;

    public String getNomCollection() {
        return BeanUtils.trimOrNull(nomCollection.getValueSafe());
    }

    public void setNomCollection(String nomCollection) {
        this.nomCollection.setValue(BeanUtils.trimOrNull(nomCollection));
    }

    public StringProperty nomCollectionProperty() {
        return nomCollection;
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
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
        if (!simple)
            lb = StringUtils.ajoutString(lb, BeanUtils.formatTitre(editeur.getNomEditeur()), " ", "(", ")");
        return lb;
    }

}
