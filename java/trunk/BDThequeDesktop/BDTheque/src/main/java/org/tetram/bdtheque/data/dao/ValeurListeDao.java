package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.dao.mappers.ValeurListeMapper;

import java.util.Map;
import java.util.UUID;

/**
 * Created by Thierry on 28/05/2014.
 */
@Repository
@Lazy
public class ValeurListeDao extends AbstractDao<ValeurListe, UUID> {

    @Autowired
    private ValeurListeMapper valeurListeMapper;

    private Map<CategorieValeurListe, DefaultValeurListe> defaultValues = null;

    private ValeurListe getDefaultValeur(CategorieValeurListe categorie) {
        if (defaultValues == null) defaultValues = valeurListeMapper.getListDefaultValeur();
        if (defaultValues == null) return null;

        DefaultValeurListe defaultValeurListe = defaultValues.get(categorie);
        if (defaultValeurListe == null)
            return null;
        else
            return defaultValeurListe.getValeur();
    }

    public ValeurListe getDefaultEtat() {
        return getDefaultValeur(CategorieValeurListe.ETAT);
    }

    public ValeurListe getDefaultReliure() {
        return getDefaultValeur(CategorieValeurListe.RELIURE);
    }

    public ValeurListe getDefaultTypeEdition() {
        return getDefaultValeur(CategorieValeurListe.TYPE_EDITION);
    }

    public ValeurListe getDefaultOrientation() {
        return getDefaultValeur(CategorieValeurListe.ORIENTATION);
    }

    public ValeurListe getDefaultFormatEdition() {
        return getDefaultValeur(CategorieValeurListe.FORMAT_EDITION);
    }

    public ValeurListe getDefaultTypeCouverture() {
        return getDefaultValeur(CategorieValeurListe.TYPE_COUVERTURE);
    }

    public ValeurListe getDefaultTypeParaBD() {
        return getDefaultValeur(CategorieValeurListe.TYPE_PARABD);
    }

    public ValeurListe getDefaultSensLecture() {
        return getDefaultValeur(CategorieValeurListe.SENS_LECTURE);
    }

    public ValeurListe getDefaultNotation() {
        return getDefaultValeur(CategorieValeurListe.NOTATION);
    }

    public ValeurListe getDefaultTypePhoto() {
        return getDefaultValeur(CategorieValeurListe.TYPE_PHOTO);
    }

}
