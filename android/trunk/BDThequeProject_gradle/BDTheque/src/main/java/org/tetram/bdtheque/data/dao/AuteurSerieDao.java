package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.AuteurSerieBean;
import org.tetram.bdtheque.data.bean.abstracts.SerieBeanAbstract;
import org.tetram.bdtheque.data.factories.AuteurSerieFactory;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class AuteurSerieDao extends CommonDaoImpl<AuteurSerieBean> {
    public AuteurSerieDao(Context context) {
        super(context);
    }

    public List<AuteurSerieBean> getAuteurs(SerieBeanAbstract serie) {
        DaoUtils.QueryInfo queryInfo = DaoUtils.getQueryInfo(this.getBeanClass());
        queryInfo.getLoadDescriptor().getChildAlias().get("serie");


        List<AuteurSerieBean> list = new ArrayList<>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    String.format("%1$s p inner join %2$s a on p.%3$s = a.%3$s", DDLConstants.PERSONNES_TABLENAME, DDLConstants.AUTEURS_SERIES_TABLENAME, DDLConstants.PERSONNES_ID),
                    null,
                    String.format("a.%1$s = ?", DDLConstants.SERIES_ID),
                    new String[]{StringUtils.UUIDToGUIDString(serie.getId())},
                    null,
                    null,
                    "p." + DDLConstants.PERSONNES_NOM + " collate nocase",
                    null
            );

            try {
                final AuteurSerieFactory factory = new AuteurSerieFactory();
                while (cursor.moveToNext()) {
                    AuteurSerieBean auteur = factory.loadFromCursor(getContext(), cursor, false, null);
                    if (auteur != null)
                        list.add(auteur);
                }
                return list;
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }
    }

}
