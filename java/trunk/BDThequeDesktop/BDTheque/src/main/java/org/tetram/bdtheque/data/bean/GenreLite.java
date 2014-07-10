package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.BeanUtils;
import org.tetram.bdtheque.data.bean.abstractentities.AbstractScriptEntity;
import org.tetram.bdtheque.data.dao.DaoScriptImpl;

import java.util.Comparator;

/**
 * Created by Thierry on 24/05/2014.
 */
@SuppressWarnings("UnusedDeclaration")
@DaoScriptImpl.ScriptInfo(typeData = 5)
public class GenreLite extends AbstractScriptEntity {

    public static Comparator<GenreLite> DEFAULT_COMPARATOR = (o1, o2) -> {
        if (o1 == o2) return 0;

        int comparaison;

        comparaison = BeanUtils.compare(o1.getGenre(), o2.getGenre());
        if (comparaison != 0) return comparaison;

        return 0;
    };
    private String genre;
    private Integer quantite;

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
    public String buildLabel() {
        return genre;
    }

}
