package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.spring.SpringContext;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.dao.ValeurListeDao;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
public class SerieLite extends AbstractDBEntity implements EvaluatedEntity {

    public static Comparator<SerieLite> DEFAULT_COMPARATOR = new Comparator<SerieLite>() {
        @Override
        public int compare(SerieLite o1, SerieLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getTitreSerie(), o2.getTitreSerie());
            if (comparaison != 0) return comparaison;

            comparaison = EditeurLite.DEFAULT_COMPARATOR.compare(o1.getEditeur(), o2.getEditeur());
            if (comparaison != 0) return comparaison;

            comparaison = CollectionLite.DEFAULT_COMPARATOR.compare(o1.getCollection(), o2.getCollection());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private StringProperty titreSerie = new SimpleStringProperty(this, "titreSerie", null);
    private ObjectProperty<EditeurLite> editeur = new SimpleObjectProperty<>(this, "editeur", null);
    private ObjectProperty<CollectionLite> collection = new SimpleObjectProperty<>(this, "collection", null);
    private ObjectProperty<ValeurListe> notation = new SimpleObjectProperty<>(this, "notation", SpringContext.CONTEXT.getBean(ValeurListeDao.class).getDefaultNotation());

    public String getTitreSerie() {
        return BeanUtils.trimOrNull(titreSerie.get());
    }

    public void setTitreSerie(String titreSerie) {
        this.titreSerie.set(BeanUtils.trimOrNull(titreSerie));
    }

    public StringProperty titreSerieProperty() {
        return titreSerie;
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

    public CollectionLite getCollection() {
        return collection.get();
    }

    public void setCollection(CollectionLite collection) {
        this.collection.set(collection);
    }

    public ObjectProperty<CollectionLite> collectionProperty() {
        return collection;
    }

    public ValeurListe getNotation() {
        return notation.get();
    }

    public void setNotation(ValeurListe notation) {
        this.notation.set(notation == null || notation.getValeur() == 0 ? SpringContext.CONTEXT.getBean(ValeurListeDao.class).getDefaultNotation() : notation);
    }

    public ObjectProperty<ValeurListe> notationProperty() {
        return notation;
    }

    @Override
    public String buildLabel() {
        String lb = getTitreSerie();
        lb = BeanUtils.formatTitre(lb);
        String s = "";
        if (getEditeur() != null)
            s = StringUtils.ajoutString("", BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ");
        if (getCollection() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getCollection().getNomCollection()), " - ");
        return StringUtils.ajoutString(lb, s, " ", "(", ")");
    }

}
