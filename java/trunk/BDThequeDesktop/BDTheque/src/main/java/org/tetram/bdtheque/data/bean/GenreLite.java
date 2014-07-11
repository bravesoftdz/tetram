package org.tetram.bdtheque.data.bean;

import javafx.beans.property.ListProperty;
import javafx.beans.property.SimpleListProperty;
import javafx.collections.FXCollections;
import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractDBEntity;
import org.tetram.bdtheque.data.bean.interfaces.ScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

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
    private String genre;
    private Integer quantite;
    private final ListProperty<String> associations = new SimpleListProperty<>(this, "associations", FXCollections.observableArrayList());

    public String getGenre() {
        return BeanUtils.trimOrNull(genre);
    }

    public void setGenre(String genre) {
        this.genre = BeanUtils.trimOrNull(genre);
    }

    public Integer getQuantite() {
        return quantite;
    }

    public void setQuantite(Integer quantite) {
        this.quantite = quantite;
    }

    @Override
    public ListProperty<String> associationsProperty() {
        return associations;
    }

    @Override
    public String buildLabel() {
        return genre;
    }

}
