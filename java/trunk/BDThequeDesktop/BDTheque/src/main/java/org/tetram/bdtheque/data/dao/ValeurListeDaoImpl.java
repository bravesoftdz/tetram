package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.CategorieValeurListe;
import org.tetram.bdtheque.data.bean.DefaultValeurListe;
import org.tetram.bdtheque.data.bean.ValeurListe;
import org.tetram.bdtheque.data.dao.mappers.ValeurListeMapper;

import java.util.List;
import java.util.Map;

/**
 * Created by Thierry on 28/05/2014.
 */
@Repository
@Lazy
@Transactional(propagation = Propagation.NOT_SUPPORTED)
@SuppressWarnings("UnusedDeclaration")
public class ValeurListeDaoImpl implements ValeurListeDao {

    @Autowired
    private ValeurListeMapper valeurListeMapper;

    private Map<CategorieValeurListe, DefaultValeurListe> defaultValues = null;

    @Override
    public List<ValeurListe> getListValeurListe(CategorieValeurListe categorie) {
        return valeurListeMapper.getListValeurListe(categorie);
    }

    private ValeurListe getDefaultValeur(CategorieValeurListe categorie) {
        if (defaultValues == null) defaultValues = valeurListeMapper.getListDefaultValeur();
        if (defaultValues == null) return null;

        DefaultValeurListe defaultValeurListe = defaultValues.get(categorie);
        if (defaultValeurListe == null)
            return null;
        else
            return defaultValeurListe.getValeur();
    }

    @Override
    public ValeurListe getDefaultEtat() {
        return getDefaultValeur(CategorieValeurListe.ETAT);
    }

    @Override
    public ValeurListe getDefaultReliure() {
        return getDefaultValeur(CategorieValeurListe.RELIURE);
    }

    @Override
    public ValeurListe getDefaultTypeEdition() {
        return getDefaultValeur(CategorieValeurListe.TYPE_EDITION);
    }

    @Override
    public ValeurListe getDefaultOrientation() {
        return getDefaultValeur(CategorieValeurListe.ORIENTATION);
    }

    @Override
    public ValeurListe getDefaultFormatEdition() {
        return getDefaultValeur(CategorieValeurListe.FORMAT_EDITION);
    }

    @Override
    public ValeurListe getDefaultTypeCouverture() {
        return getDefaultValeur(CategorieValeurListe.TYPE_COUVERTURE);
    }

    @Override
    public ValeurListe getDefaultTypeParaBD() {
        return getDefaultValeur(CategorieValeurListe.TYPE_PARABD);
    }

    @Override
    public ValeurListe getDefaultSensLecture() {
        return getDefaultValeur(CategorieValeurListe.SENS_LECTURE);
    }

    @Override
    public ValeurListe getDefaultNotation() {
        return getDefaultValeur(CategorieValeurListe.NOTATION);
    }

    @Override
    public ValeurListe getDefaultTypePhoto() {
        return getDefaultValeur(CategorieValeurListe.TYPE_PHOTO);
    }

}
