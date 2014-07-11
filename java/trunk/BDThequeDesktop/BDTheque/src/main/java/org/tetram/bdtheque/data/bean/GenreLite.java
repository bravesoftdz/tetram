package org.tetram.bdtheque.data.bean;

import javafx.beans.property.*;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;
import org.tetram.bdtheque.spring.utils.AutoTrimStringProperty;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 5)
public class GenreLite extends AbstractDBEntity implements ScriptEntity {

    public static Comparator<GenreLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getGenre(), o2.getGenre());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private final StringProperty genre = new AutoTrimStringProperty(this, "genre", null);
    private final IntegerProperty quantite = new SimpleIntegerProperty(this, "quantite", 0);
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    static {
        baseClass = GenreLite.class;
    }


    public String getGenre() {
        return genre.get();
    }

    public void setGenre(String genre) {
        this.genre.set(genre);
    }

    public StringProperty genreProperty() {
        return genre;
    }

    public int getQuantite() {
        return quantite.get();
    }

    public void setQuantite(int quantite) {
        this.quantite.set(quantite);
    }

    public IntegerProperty quantiteProperty() {
        return quantite;
    }

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public String buildLabel() {
        return getGenre();
    }

}
