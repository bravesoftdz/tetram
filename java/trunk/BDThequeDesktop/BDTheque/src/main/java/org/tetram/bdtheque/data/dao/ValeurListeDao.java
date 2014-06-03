package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.dao.mappers.ValeurListeMapper;

import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 28/05/2014.
 */
@Configuration
public class ValeurListeDao extends AbstractDao<ValeurListe, UUID> {

    @Autowired
    private ValeurListeMapper valeurListeMapper;

    private Map<CategorieValeurListe, DefaultValeurListe> defaultValues = null;

    private ValeurListe getValeur(CategorieValeurListe categorie) {
        // defaultValues = getSqlSession().selectMap("getListDefaultValeur", "categorie");
        if (defaultValues == null) defaultValues = valeurListeMapper.getListDefaultValeur();
        if (defaultValues == null) return null;

        DefaultValeurListe defaultValeurListe = defaultValues.get(categorie);
        if (defaultValeurListe == null)
            return null;
        else
            return defaultValeurListe.getValeur();
    }

    public ValeurListe getDefaultEtat() {
        return getValeur(CategorieValeurListe.ETAT);
    }

    public ValeurListe getDefaultReliure() {
        return getValeur(CategorieValeurListe.RELIURE);
    }

    public ValeurListe getDefaultTypeEdition() {
        return getValeur(CategorieValeurListe.TYPE_EDITION);
    }

    public ValeurListe getDefaultOrientation() {
        return getValeur(CategorieValeurListe.ORIENTATION);
    }

    public ValeurListe getDefaultFormatEdition() {
        return getValeur(CategorieValeurListe.FORMAT_EDITION);
    }

    public ValeurListe getDefaultTypeCouverture() {
        return getValeur(CategorieValeurListe.TYPE_COUVERTURE);
    }

    public ValeurListe getDefaultTypeParaBD() {
        return getValeur(CategorieValeurListe.TYPE_PARABD);
    }

    public ValeurListe getDefaultSensLecture() {
        return getValeur(CategorieValeurListe.SENS_LECTURE);
    }

    public ValeurListe getDefaultNotation() {
        return getValeur(CategorieValeurListe.NOTATION);
    }

    public ValeurListe getDefaultTypePhoto() {
        return getValeur(CategorieValeurListe.TYPE_PHOTO);
    }

}
