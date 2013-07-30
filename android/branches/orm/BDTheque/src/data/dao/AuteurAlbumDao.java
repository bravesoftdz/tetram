package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.AuteurAlbumBean;
import org.tetram.bdtheque.data.bean.abstracts.AlbumBeanAbstract;
import org.tetram.bdtheque.data.factories.AuteurAlbumFactory;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class AuteurAlbumDao extends CommonDaoImpl<AuteurAlbumBean> {
    public AuteurAlbumDao(Context context) {
        super(context);
    }

    public List<AuteurAlbumBean> getAuteurs(AlbumBeanAbstract album) {
        List<AuteurAlbumBean> list = new ArrayList<>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        try {
            Cursor cursor = rdb.query(
                    String.format("%1$s p inner join %2$s a on p.%3$s = a.%3$s", DDLConstants.PERSONNES_TABLENAME, DDLConstants.AUTEURS_ALBUMS_TABLENAME, DDLConstants.PERSONNES_ID),
                    null,
                    String.format("a.%1$s = ?", DDLConstants.ALBUMS_ID),
                    new String[]{StringUtils.UUIDToGUIDString(album.getId())},
                    null,
                    null,
                    "p." + DDLConstants.PERSONNES_NOM + " collate nocase",
                    null
            );

            try {
                final AuteurAlbumFactory factory = new AuteurAlbumFactory();
                while (cursor.moveToNext()) {
                    AuteurAlbumBean auteur = factory.loadFromCursor(getContext(), cursor, false, null);
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
