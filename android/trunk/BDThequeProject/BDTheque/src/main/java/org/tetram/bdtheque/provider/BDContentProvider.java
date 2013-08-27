package org.tetram.bdtheque.provider;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.net.Uri;

import org.jetbrains.annotations.Nullable;

import static org.tetram.bdtheque.provider.BDThequeContracts.AUTORITHY;
import static org.tetram.bdtheque.provider.BDThequeContracts.TABLE_ALBUM;
import static org.tetram.bdtheque.provider.BDThequeContracts.TABLE_SERIE;

public class BDContentProvider extends ContentProvider {

    private static final UriMatcher uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);

    private static final int TABLE_MASK = 0x1 + 0x2;
    private static final int ROW_MASK = 0x4;

    private static final int TABLE_ALBUM_CODE = 0x01;
    private static final int TABLE_SERIE_CODE = 0x02;

    private static final String MIME_TYPE_ROW = "vnd.android.cursor.item";
    private static final String MIME_TYPE_ROWS = "vnd.android.cursor.dir";
    private static final String MIME_SUBTYPE_PREFIX = "vnd."+AUTORITHY;
    private static final String MIME_TYPE_FORMAT = "%.1s/" + MIME_SUBTYPE_PREFIX + ".%.3s";


    @Override
    public boolean onCreate() {
        uriMatcher.addURI(AUTORITHY, TABLE_ALBUM, TABLE_ALBUM_CODE);
        uriMatcher.addURI(AUTORITHY, TABLE_ALBUM + "/#", TABLE_ALBUM_CODE + ROW_MASK);
        uriMatcher.addURI(AUTORITHY, TABLE_SERIE, TABLE_SERIE_CODE);
        uriMatcher.addURI(AUTORITHY, TABLE_SERIE + "/#", TABLE_SERIE_CODE + ROW_MASK);
        return false;
    }

    @Nullable
    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        int uriCode = uriMatcher.match(uri);

        Integer id;
        if ((uriCode & ROW_MASK) == ROW_MASK)
            id = Integer.valueOf(uri.getLastPathSegment());

        switch (uriCode & TABLE_MASK) {
            default:
                return null;
        }
    }

    @Nullable
    @Override
    public String getType(Uri uri) {
        int uriCode = uriMatcher.match(uri);

        String mimeType;
        if ((uriCode & ROW_MASK) == ROW_MASK)
            mimeType = MIME_TYPE_ROW;
        else
            mimeType = MIME_TYPE_ROWS;

        String mimeTable;

        switch (uriCode & TABLE_MASK) {
            case TABLE_ALBUM_CODE:
                mimeTable = BDThequeContracts.TABLE_ALBUM;
                break;
            case TABLE_SERIE_CODE:
                mimeTable = BDThequeContracts.TABLE_SERIE;
                break;
            default:
                return null;
        }

        return String.format(MIME_TYPE_FORMAT, mimeType, mimeTable);
    }

    @Nullable
    @Override
    public Uri insert(Uri uri, ContentValues values) {
        return null;
    }

    @Override
    public int delete(Uri uri, String selection, String[] selectionArgs) {
        return 0;
    }

    @Override
    public int update(Uri uri, ContentValues values, String selection, String[] selectionArgs) {
        return 0;
    }
}
