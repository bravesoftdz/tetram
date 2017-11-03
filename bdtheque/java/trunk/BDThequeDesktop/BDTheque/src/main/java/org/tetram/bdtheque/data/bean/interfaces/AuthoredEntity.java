/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * AuthoredEntity.java
 * Last modified by Tetram, on 2014-07-29T11:09:14CEST
 */

package org.tetram.bdtheque.data.bean.interfaces;

import javafx.beans.property.ListProperty;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import org.tetram.bdtheque.data.bean.AuteurSerieLite;
import org.tetram.bdtheque.data.bean.MetierAuteur;
import org.tetram.bdtheque.data.bean.PersonneLite;

import java.util.List;

/**
 * Created by Thierry on 28/07/2014.
 */
public interface AuthoredEntity<A extends AuteurSerieLite> extends DBEntity {

    default void initAuthors() {
        auteursProperty().addListener((observable, oldValue, newValue) -> buildListsAuteurs());
        auteursProperty().addListener((ListChangeListener<A>) c -> buildListsAuteurs());
    }

    A getNewAuthor();

    ListProperty<A> auteursProperty();

    default List<A> getAuteurs() {
        return auteursProperty().get();
    }

    default void setAuteurs(List<A> auteurs) {
        this.auteursProperty().set(FXCollections.observableList(auteurs));
    }

    default void buildListsAuteurs() {
        int countAuteurs = scenaristesProperty().size() + dessinateursProperty().size() + coloristesProperty().size();

        if (auteursProperty().size() != countAuteurs) {
            scenaristesProperty().set(FXCollections.observableArrayList());
            dessinateursProperty().set(FXCollections.observableArrayList());
            coloristesProperty().set(FXCollections.observableArrayList());
            for (A a : auteursProperty()) {
                switch (a.getMetier()) {
                    case SCENARISTE:
                        scenaristesProperty().add(a);
                        break;
                    case DESSINATEUR:
                        dessinateursProperty().add(a);
                        break;
                    case COLORISTE:
                        coloristesProperty().add(a);
                        break;
                }
            }
        }
    }

    default void addAuteur(PersonneLite personne, List<A> listAuteurs, MetierAuteur metier) {
        for (A auteur : listAuteurs)
            if (auteur.getPersonne().equals(personne)) return;

        A auteur = getNewAuthor();
        auteur.setPersonne(personne);
        auteur.setMetier(metier);
        auteursProperty().add(auteur);
    }

    default void addScenariste(PersonneLite personne) {
        addAuteur(personne, getScenaristes(), MetierAuteur.SCENARISTE);
    }

    default void addDessinateur(PersonneLite personne) {
        addAuteur(personne, getDessinateurs(), MetierAuteur.DESSINATEUR);
    }

    default void addColoriste(PersonneLite personne) {
        addAuteur(personne, getColoristes(), MetierAuteur.COLORISTE);
    }

    default void removeAuteur(PersonneLite personne, List<A> auteurs) {
        auteurs.removeIf(a -> a.getPersonne().equals(personne));
    }

    default void removeScenariste(PersonneLite personne) {
        removeAuteur(personne, getScenaristes());
    }

    default void removeDessinateur(PersonneLite personne) {
        removeAuteur(personne, getDessinateurs());
    }

    default void removeColoriste(PersonneLite personne) {
        removeAuteur(personne, getColoristes());
    }

    default List<A> getScenaristes() {
        return scenaristesProperty().get();
    }

    ListProperty<A> scenaristesProperty();

    default List<A> getDessinateurs() {
        return dessinateursProperty().get();
    }

    ListProperty<A> dessinateursProperty();

    default List<A> getColoristes() {
        return coloristesProperty().get();
    }

    ListProperty<A> coloristesProperty();
}
