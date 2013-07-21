package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.factories.EditionFactory;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.List;
import java.util.UUID;

public class EditionDao extends CommonDaoImpl<EditionBean> {
    public EditionDao(Context context) {
        super(context);
    }

    public void loadListForAlbum(List<EditionBean> editions, UUID albumId) {
        loadListForAlbum(editions, albumId, null);
    }

    @SuppressWarnings("UnusedParameters")
    public void loadListForAlbum(List<EditionBean> editions, UUID albumId, Boolean stock) {
        editions.clear();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    DDLConstants.EDITIONS_TABLENAME,
                    null,
                    String.format("%1$s = ?", DDLConstants.ALBUMS_ID),
                    new String[]{StringUtils.UUIDToGUIDString(albumId)},
                    null,
                    null,
                    null,
                    null
            );

            try {
                final EditionFactory factory = new EditionFactory();
                while (cursor.moveToNext()) {
                    EditionBean editionBean = factory.loadFromCursor(getContext(), cursor, false);
                    if (editionBean != null)
                        editions.add(editionBean);
                }
            } finally {
                cursor.close();
            }
        } finally {
            rdb.close();
        }

    }
}
