package org.tetram.bdtheque.data.dao.lite;

import android.content.Context;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.PersonneLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;

public class PersonneLiteDao extends CommonRepertoireDao<PersonneLiteBean, InitialeBean> {

    public PersonneLiteDao(Context context) {
        super(InitialeBean.class);
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(DDLConstants.PERSONNES_TABLENAME, DDLConstants.PERSONNES_INITIALE, getFiltre(R.string.sql_searchfield_personnes));
    }

    @Override
    public List<PersonneLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_personnes_by_initiale, initiale, getFiltre(R.string.sql_searchfield_personnes));
    }

}
