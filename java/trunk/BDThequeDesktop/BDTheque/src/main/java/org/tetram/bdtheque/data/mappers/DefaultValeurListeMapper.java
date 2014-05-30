package org.tetram.bdtheque.data.mappers;

import org.apache.ibatis.session.SqlSession;
import org.tetram.bdtheque.data.Database;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by Thierry on 28/05/2014.
 */
public class DefaultValeurListeMapper {
    private static DefaultValeurListeMapper ourInstance = null;
    private Map<CategorieValeurListe, DefaultValeurListe> defaultValues = new HashMap<>();

    private DefaultValeurListeMapper() {
        SqlSession session = Database.getInstance().openSession();
        defaultValues = session.selectMap("getListDefaultValeur", "categorie");
    }

    public static DefaultValeurListeMapper getInstance() {
        if (ourInstance == null)
            ourInstance = new DefaultValeurListeMapper();
        return ourInstance;
    }

    private ValeurListe getValeur(CategorieValeurListe categorie) {
        DefaultValeurListe defaultValeurListe = defaultValues.get(categorie);
        if (defaultValeurListe == null)
            return null;
        else
            return defaultValeurListe.getValeur();
    }

    public ValeurListe getEtat() {
        return getValeur(CategorieValeurListe.ETAT);
    }

    public ValeurListe getReliure() {
        return getValeur(CategorieValeurListe.RELIURE);
    }

    public ValeurListe getTypeEdition() {
        return getValeur(CategorieValeurListe.TYPE_EDITION);
    }

    public ValeurListe getOrientation() {
        return getValeur(CategorieValeurListe.ORIENTATION);
    }

    public ValeurListe getFormatEdition() {
        return getValeur(CategorieValeurListe.FORMAT_EDITION);
    }

    public ValeurListe getTypeCouverture() {
        return getValeur(CategorieValeurListe.TYPE_COUVERTURE);
    }

    public ValeurListe getTypeParaBD() {
        return getValeur(CategorieValeurListe.TYPE_PARABD);
    }

    public ValeurListe getSensLecture() {
        return getValeur(CategorieValeurListe.SENS_LECTURE);
    }

    public ValeurListe getNotation() {
        return getValeur(CategorieValeurListe.NOTATION);
    }

    public ValeurListe getTypePhoto() {
        return getValeur(CategorieValeurListe.TYPE_PHOTO);
    }

}
