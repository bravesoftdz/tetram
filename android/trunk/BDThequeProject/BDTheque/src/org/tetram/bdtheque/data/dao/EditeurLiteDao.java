package org.tetram.bdtheque.data.dao;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.EditeurLiteBean;
import org.tetram.bdtheque.data.factories.EditeurLiteFactory;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;

@SuppressWarnings("UnusedDeclaration")
public class EditeurLiteDao extends CommonRepertoireDao<EditeurLiteBean, InitialeBean> {

    public EditeurLiteDao(Context context) {
        super(context, InitialeBean.class, EditeurLiteFactory.class);
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(DDLConstants.EDITEURS_TABLENAME, DDLConstants.EDITEURS_INITIALE, getFiltre(R.string.sql_searchfield_editeurs));
    }

    @Override
    public List<EditeurLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_editeurs_by_initiale, initiale, getFiltre(R.string.sql_searchfield_editeurs));
    }
}
