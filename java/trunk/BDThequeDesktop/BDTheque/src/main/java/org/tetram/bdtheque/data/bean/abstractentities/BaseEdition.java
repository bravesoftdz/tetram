/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * BaseEdition.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.abstractentities;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;
import javafx.beans.property.StringProperty;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.CollectionLite;
import org.tetram.bdtheque.data.bean.EditeurLite;
import org.tetram.bdtheque.data.bean.EditionLite;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;
import org.tetram.bdtheque.utils.I18nSupport;
import org.tetram.bdtheque.utils.ISBNUtils;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.TypeUtils;

import java.time.Year;
import java.util.Comparator;

/**
 * Created by Thierry on 11/07/2014.
 */

public abstract class BaseEdition<E extends BaseEditeur, C extends BaseCollection> extends AbstractDBEntity {

    public static Comparator<EditionLite> DEFAULT_COMPARATOR = (o1, o2) -> {
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
    };
    private final ObjectProperty<Year> anneeEdition = new SimpleObjectProperty<>(this, "anneeEdition", null);
    private final StringProperty isbn = new AutoTrimStringProperty(this, "isbn", null);
    private final ObjectProperty<E> editeur = new SimpleObjectProperty<>(this, "editeur", null);
    private final ObjectProperty<C> collection = new SimpleObjectProperty<>(this, "collection", null);

    @Override
    public Class<? extends AbstractDBEntity> getBaseClass() {
        return BaseEdition.class;
    }


    public Year getAnneeEdition() {
        return anneeEdition.get();
    }

    public void setAnneeEdition(Year anneeEdition) {
        this.anneeEdition.set(anneeEdition);
    }

    public ObjectProperty<Year> anneeEditionProperty() {
        return anneeEdition;
    }

    public String getIsbn() {
        return isbn.get();
    }

    public void setIsbn(String isbn) {
        this.isbn.set(isbn);
    }

    public StringProperty isbnProperty() {
        return isbn;
    }

    public E getEditeur() {
        return editeur.get();
    }

    public void setEditeur(E editeur) {
        this.editeur.set(editeur);
        if (editeur == null)
            setCollection(null);
    }

    public ObjectProperty<E> editeurProperty() {
        return editeur;
    }

    public C getCollection() {
        return collection.get();
    }

    public void setCollection(C collection) {
        this.collection.set(collection);
    }

    public ObjectProperty<C> collectionProperty() {
        return collection;
    }

    @Override
    public String buildLabel() {
        String s = "";
        if (getEditeur() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getEditeur().getNomEditeur()), " ");
        if (getCollection() != null)
            s = StringUtils.ajoutString(s, BeanUtils.formatTitre(getCollection().getNomCollection()), " ", "(", ")");
        s = StringUtils.ajoutString(s, TypeUtils.nonZero(getAnneeEdition()), " ", "[", "]");
        s = StringUtils.ajoutString(s, ISBNUtils.formatISBN(getIsbn()), " - ", I18nSupport.message("isbn") + " ");
        return s;
    }
}
