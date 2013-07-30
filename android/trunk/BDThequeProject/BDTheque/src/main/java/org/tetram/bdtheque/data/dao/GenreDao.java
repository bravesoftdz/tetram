package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.GenreBean;
import org.tetram.bdtheque.data.factories.FactoriesFactory;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

public class GenreDao extends CommonDaoImpl<GenreBean> {
    public GenreDao(Context context) {
        super(context);
    }

    public void loadListForSerie(List<GenreBean> list, UUID serieId) {
        list.clear();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    String.format("%1$s g inner join %2$s gs on g.%3$s = gs.%3$s", this.getDescriptor().getTableName(), DDLConstants.GENRESERIES_TABLENAME, DDLConstants.GENRES_ID),
                    new String[]{"g.*"},
                    String.format("gs.%1$s = ?", DDLConstants.SERIES_ID),
                    new String[]{StringUtils.UUIDToGUIDString(serieId)},
                    null,
                    null,
                    "g." + DDLConstants.GENRES_NOM,
                    null
            );
            try {
                while (cursor.moveToNext()) {
                    GenreBean genre = (GenreBean) FactoriesFactory.getFactoryForBean(this.getBeanClass()).loadFromCursor(getContext(), cursor, false, null);
                    if (genre != null)
                        list.add(genre);
                }
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }
    }
}
