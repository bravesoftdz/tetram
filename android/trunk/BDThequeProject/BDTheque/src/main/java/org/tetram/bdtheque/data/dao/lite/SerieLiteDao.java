package org.tetram.bdtheque.data.dao.lite;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.dao.CommonRepertoireDao;
import org.tetram.bdtheque.database.DDLConstants;

import java.util.List;

public class SerieLiteDao extends CommonRepertoireDao<SerieLiteBean, InitialeBean> {

    public SerieLiteDao() {
        super(InitialeBean.class);
    }

    @Override
    public List<InitialeBean> getInitiales() {
        return super.getInitiales(DDLConstants.SERIES_TABLENAME, DDLConstants.SERIES_INITIALE, getFiltre(R.string.sql_searchfield_series));
    }

    @Override
    public List<SerieLiteBean> getData(InitialeBean initiale) {
        return super.getData(R.string.sql_series_by_initiale, initiale, getFiltre(R.string.sql_searchfield_series));
    }

}
