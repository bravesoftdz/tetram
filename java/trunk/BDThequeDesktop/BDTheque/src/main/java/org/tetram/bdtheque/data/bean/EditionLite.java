package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.utils.StringUtils;

/**
 * Created by Thierry on 24/05/2014.
 */
public class EditionLite extends AbstractDBEntity {
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
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
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
        s = StringUtils.ajoutString("", StringUtils.formatTitre(editeur.getNomEditeur()), " ");
        s = StringUtils.ajoutString(s, StringUtils.formatTitre(collection.getNomCollection()), " ", "(", ")");
        s = StringUtils.ajoutString(s, StringUtils.nonZero(anneeEdition), " ", "[", "]");
        s = StringUtils.ajoutString(s, StringUtils.formatISBN(isbn), " - ", "ISBN ");
        return s;
    }
}
