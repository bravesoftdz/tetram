package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeSerieBean;
import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.data.factories.lite.AlbumLiteAbstractFactory;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;

@SuppressWarnings("UnusedDeclaration")
public class BibliographieDao extends CommonRepertoireDao<AlbumLiteBean.AlbumWithoutSerieLiteBean, InitialeSerieBean> {

    private PersonneBean personne;

    public BibliographieDao(Context context) {
        super(context, InitialeSerieBean.class, AlbumLiteAbstractFactory.AlbumWithoutSerieLiteFactory.class);
    }

    private String buildFiltre() {
        String filtre = getFiltre(R.string.sql_searchfield_albums);
        if (!"".equals(filtre)) filtre += " and ";
        return filtre;
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<InitialeSerieBean> getInitiales() {
        return super.getInitiales(R.string.sql_series_albums_for_auteur, buildFiltre() + String.format("aa.%s = '%s'", DDLConstants.PERSONNES_ID, StringUtils.UUIDToGUIDString(this.personne.getId())));
    }

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    @Override
    public List<AlbumLiteBean.AlbumWithoutSerieLiteBean> getData(InitialeSerieBean initiale) {
        return super.getData(R.string.sql_albums_by_serie_for_auteur, initiale, buildFiltre() + String.format("aa.%s = '%s'", DDLConstants.PERSONNES_ID, StringUtils.UUIDToGUIDString(this.personne.getId())));
    }

    public void setPersonne(PersonneBean personne) {
        this.personne = personne;
    }

    public PersonneBean getPersonne() {
        return this.personne;
    }
}
