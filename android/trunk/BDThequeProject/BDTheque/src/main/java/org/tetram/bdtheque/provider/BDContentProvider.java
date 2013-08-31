package org.tetram.bdtheque.provider;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.os.CancellationSignal;
import android.text.TextUtils;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.Core;
import org.tetram.bdtheque.data.orm.QueryInfo;
import org.tetram.bdtheque.data.orm.SQLDescriptor;
import org.tetram.bdtheque.database.BDDatabaseHelper;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static android.provider.BaseColumns._ID;
import static org.tetram.bdtheque.provider.BDThequeContracts.AUTORITHY;
import static org.tetram.bdtheque.provider.BDThequeContracts.SCHEME;

public class BDContentProvider extends ContentProvider {

    private BDDatabaseHelper dbHelper;
    private static final UriMatcher uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);

    private static final int TABLE_MASK = 0x1 | 0x2;
    private static final int ROW_MASK = 0x4;

    private static final int TABLE_ALBUM_CODE = 0x01;
    private static final int TABLE_SERIE_CODE = 0x02;

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    private static final Uri BASE_URI = Uri.parse(SCHEME + AUTORITHY);

    private static final HashMap<String, Class<? extends CommonBean>> tablesMap = new HashMap<String, Class<? extends CommonBean>>();

    @SuppressWarnings("unchecked")
    @Nullable
    public static List<Class<? extends CommonBean>> getClasses(String pckgname) {
        ArrayList<Class<? extends CommonBean>> classes = new ArrayList<Class<? extends CommonBean>>();

        ClassLoader cld = Thread.currentThread().getContextClassLoader();
        if (cld == null) return null;

        String path = pckgname.replace('.', '/');
        URL resource = cld.getResource(path);
        if (resource == null) return null;

        File directory = new File(resource.getFile());

        if (directory.exists()) {
            // Get the list of the files contained in the package
            for (String fileName : directory.list()) {
                // we are only interested in .class files
                if (fileName.endsWith(".class")) {
                    // removes the .class extension
                    try {
                        Class<?> aClass = Class.forName(pckgname + '.' + fileName.substring(0, fileName.length() - 6));
                        if (CommonBean.class.isAssignableFrom(aClass))
                            classes.add((Class<? extends CommonBean>) aClass);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    }
                } else {
                    File file = new File(directory, fileName);
                    if (file.isDirectory())
                        classes.addAll(getClasses(pckgname + '.' + fileName));
                }
            }
        }
        return classes;
    }

    static {
        for (Class<? extends CommonBean> aClass : getClasses(CommonBean.class.getPackage().getName())) {
            ExportProvider a = aClass.getAnnotation(ExportProvider.class);
            if ((a != null) && !TextUtils.isEmpty(a.uriTableName())) {
                tablesMap.put(a.uriTableName(), aClass);

                uriMatcher.addURI(AUTORITHY, a.uriTableName(), tablesMap.size());
                uriMatcher.addURI(AUTORITHY, a.uriTableName() + "/#", tablesMap.size() | ROW_MASK);
            }
        }
    }

    @Override
    public boolean onCreate() {
        this.dbHelper = new BDDatabaseHelper(getContext());
        return true;
    }

    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        return this.query(uri, projection, selection, selectionArgs, sortOrder, null);
    }

    @Nullable
    @Override
    public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder, CancellationSignal cancellationSignal) {
        int uriCode = uriMatcher.match(uri);

        Integer id;
        if ((uriCode & ROW_MASK) == ROW_MASK)
            id = Integer.valueOf(uri.getLastPathSegment());

        Class<? extends CommonBean> beanClass = tablesMap.get(uri.getPathSegments().get(0));
        if (beanClass == null) return null;

        SQLDescriptor descriptor = Core.getSQLDescriptor(beanClass);
        QueryInfo queryInfo = Core.getQueryInfo(beanClass);

        SQLiteQueryBuilder qry = new SQLiteQueryBuilder();
        qry.setTables(queryInfo.getTables().get(0));

        String[] qryProjections = new String[((projection != null) ? projection.length : 0) + 1];
        qryProjections[0] = String.format("%s as %s", queryInfo.getColumns().get(descriptor.getPrimaryKey().getField()).getFullFieldName(), _ID);
        if (projection != null)
            System.arraycopy(projection, 0, qryProjections, 1, projection.length);

        if ((uriCode & ROW_MASK) == ROW_MASK)
            qry.appendWhere(String.format("%s = ?", queryInfo.getColumns().get(descriptor.getPrimaryKey().getField()).getFullFieldName()));

        SQLiteDatabase rdb = this.dbHelper.getReadableDatabase();
        Cursor cursor = qry.query(rdb,
                qryProjections,
                null,
                null,
                null,
                null,
                null,
                null,
                cancellationSignal);

        cursor.setNotificationUri(getContext().getContentResolver(), uri);
        return cursor;
    }

    @Nullable
    @Override
    public String getType(Uri uri) {
        int uriCode = uriMatcher.match(uri);

        String mimeType;
        if ((uriCode & ROW_MASK) == ROW_MASK)
            mimeType = BDThequeContracts.MIME_TYPE_ROW;
        else
            mimeType = BDThequeContracts.MIME_TYPE_ROWS;

        String mimeTable = uri.getPathSegments().get(0);
        if (tablesMap.get(mimeTable) == null)
            return null;

        return String.format(BDThequeContracts.MIME_TYPE_FORMAT, mimeType, mimeTable);
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
