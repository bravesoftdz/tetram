package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AuteurLiteBean;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.factories.AuteurLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;

public class AuteurLiteDao extends CommonRepertoireDao<AuteurLiteBean, InitialeBean> {

    public AuteurLiteDao(Context context) {
        super(context, InitialeBean.class, AuteurLiteFactory.class);
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(DDLConstants.AUTEURS_TABLENAME, DDLConstants.AUTEURS_INITIALE, getFiltre(R.string.sql_searchfield_auteurs));
    }

    @Override
    public List<AuteurLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_auteurs_by_initiale, initiale, getFiltre(R.string.sql_searchfield_auteurs));
    }
}
