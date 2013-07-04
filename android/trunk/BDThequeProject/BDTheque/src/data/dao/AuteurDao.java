package org.tetram.bdtheque.data.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.data.bean.AuteurBean;
import org.tetram.bdtheque.data.bean.lite.AlbumLiteBean;
import org.tetram.bdtheque.data.bean.lite.SerieLiteBean;
import org.tetram.bdtheque.data.factories.AuteurAlbumFactory;
import org.tetram.bdtheque.data.factories.AuteurSerieFactory;
import org.tetram.bdtheque.database.DDLConstants;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class AuteurDao extends DefaultDao<AuteurBean> {
    public AuteurDao(Context context) {
        super(context);
    }

    public List<AuteurBean> getAuteurs(AlbumLiteBean album) {
        List<AuteurBean> list = new ArrayList<>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
        Cursor cursor = rdb.query(
                String.format("%1$s p inner join %2$s a on p.%3$s = a.%3$s", DDLConstants.PERSONNES_TABLENAME, DDLConstants.AUTEURS_TABLENAME, DDLConstants.PERSONNES_ID),
                null,
                String.format("a.%1$s = ?", DDLConstants.ALBUMS_ID),
                new String[]{StringUtils.UUIDToGUIDString(album.getId())},
                null,
                null,
                "p." + DDLConstants.PERSONNES_NOM + " collate nocase",
                null
        );

        final AuteurAlbumFactory factory = new AuteurAlbumFactory();
        while (cursor.moveToNext()) {
            AuteurBean auteur = factory.loadFromCursor(getContext(), cursor, true);
            if (auteur != null)
                list.add(auteur);
        }

        return list;
    }

    public List<AuteurBean> getAuteurs(SerieLiteBean serie) {
        List<AuteurBean> list = new ArrayList<>();

        SQLiteDatabase rdb = getDatabaseHelper().getReadableDatabase();
        assert rdb != null;
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

        final AuteurSerieFactory factory = new AuteurSerieFactory();
        while (cursor.moveToNext()) {
            AuteurBean auteur = factory.loadFromCursor(getContext(), cursor, true);
            if (auteur != null)
                list.add(auteur);
        }

        return list;
    }

}
