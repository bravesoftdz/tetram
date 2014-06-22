package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
public class EditionLite extends AbstractDBEntity {

    public static Comparator<EditionLite> DEFAULT_COMPARATOR = new Comparator<EditionLite>() {
        @Override
        public int compare(EditionLite o1, EditionLite o2) {
            if (o1 == o2) return 0;

            int comparaison;

            comparaison = BeanUtils.compare(o1.getAnneeEdition(), o2.getAnneeEdition());
            if (comparaison != 0) return comparaison;

            comparaison = EditeurLite.DEFAULT_COMPARATOR.compare(o1.getEditeur(), o2.getEditeur());
            if (comparaison != 0) return comparaison;

            comparaison = CollectionLite.DEFAULT_COMPARATOR.compare(o1.getCollection(), o2.getCollection());
            if (comparaison != 0) return comparaison;

            comparaison = BeanUtils.compare(o1.getIsbn(), o2.getIsbn());
            if (comparaison != 0) return comparaison;

            return 0;
        }
    };
    private Integer anneeEdition;
    private String isbn;
    private EditeurLite editeur;
    private CollectionLite collection;

    public Integer getAnneeEdition() {
        return anneeEdition;
    }

    public void setAnneeEdition(Integer anneeEdition) {
        this.anneeEdition = anneeEdition;
    }

    public String getIsbn() {
        return BeanUtils.trimOrNull(isbn);
    }

    public void setIsbn(String isbn) {
        this.isbn = BeanUtils.trimOrNull(isbn);
    }

    public EditeurLite getEditeur() {
        return editeur;
    }

    public void setEditeur(EditeurLite editeur) {
        this.editeur = editeur;
    }

    public CollectionLite getCollection() {
        return collection;
    }

    public void setCollection(CollectionLite collection) {
        this.collection = collection;
    }

    @Override
    public String buildLabel() {
        String s;
        s = StringUtils.ajoutString("", BeanUtils.formatTitre(editeur.getNomEditeur()), " ");
        s = StringUtils.ajoutString(s, BeanUtils.formatTitre(collection.getNomCollection()), " ", "(", ")");
        s = StringUtils.ajoutString(s, StringUtils.nonZero(anneeEdition), " ", "[", "]");
        s = StringUtils.ajoutString(s, BeanUtils.formatISBN(isbn), " - ", I18nSupport.message("isbn") + " ");
        return s;
    }

}
