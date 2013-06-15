package org.tetram.bdtheque.data.dao;

import android.content.Context;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.EditeurLiteBean;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.factories.EditeurLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;
import java.util.UUID;

public class EditeurLiteDao extends CommonRepertoireDao<EditeurLiteBean, InitialeBean> {

    public EditeurLiteDao(Context context) {
        super(context, InitialeBean.class, EditeurLiteFactory.class);
    }

    public EditeurLiteBean getEditeur(UUID editeurId) {
        return null;
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(DDLConstants.EDITEURS_TABLENAME, DDLConstants.EDITEURS_INITIALE);
    }

    @Override
    public List<EditeurLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_editeurs_by_initiale, initiale);
    }
}
