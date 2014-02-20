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
import org.tetram.bdtheque.utils.StringUtils;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.UUID;

import static android.provider.BaseColumns._ID;
import static org.tetram.bdtheque.provider.BDThequeContracts.AUTORITHY;
import static org.tetram.bdtheque.provider.BDThequeContracts.SCHEME;

public class BDContentProvider extends ContentProvider {

    private BDDatabaseHelper dbHelper;
    private static final UriMatcher uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);

    private static final int TABLE_MASK = 0x1 | 0x2;
    private static final int ROW_MASK = 0x4;

    @SuppressWarnings("StringConcatenationMissingWhitespace")
    private static final Uri BASE_URI = Uri.parse(SCHEME + AUTORITHY);

    private static final HashMap<String, Class<? extends CommonBean>> tablesMap = new HashMap<>();

    @SuppressWarnings("unchecked")
    @Nullable
    public static List<Class<? extends CommonBean>> getClasses(String pckgname) {
        ArrayList<Class<? extends CommonBean>> classes = new ArrayList<>();

        ClassLoader cld = Thread.currentThread().getContextClassLoader();
        if (cld == null) return null;

        String path = pckgname.replace('.', '/');
        URL resource = cld.getResource(path);
        if (resource == null) return null;

        File directory = new File(resource.getFile());

        if (directory.exists()) {
            // Get the list of the files contained in the package
            for (final String fileName : directory.list()) {
                // we are only interested in .class files
                if (fileName.endsWith(".class")) {
                    // removes the .class extension
                    try {
                        Class<?> aClass = Class.forName(pckgname + '.' + fileName.substring(0, fileName.length() - 6));
                        if (CommonBean.class.isAssignableFrom(aClass))
                            classes.add((Class<? extends CommonBean>) aClass);
                    } catch (final ClassNotFoundException e) {
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
        for (final Class<? extends CommonBean> aClass : getClasses(CommonBean.class.getPackage().getName())) {
            ExportProvider a = aClass.getAnnotation(ExportProvider.class);
            if ((a != null) && !TextUtils.isEmpty(a.uriTableName())) {
                tablesMap.put(a.uriTableName(), aClass);

                uriMatcher.addURI(AUTORITHY, a.uriTableName(), tablesMap.size());
                uriMatcher.addURI(AUTORITHY, a.uriTableName() + "/*", tablesMap.size() | ROW_MASK);
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

        Class<? extends CommonBean> beanClass = tablesMap.get(uri.getPathSegments().get(0));
        if (beanClass == null) return null;

        SQLDescriptor descriptor = Core.getSQLDescriptor(beanClass);
        QueryInfo queryInfo = Core.getQueryInfo(beanClass);

        SQLiteQueryBuilder qry = new SQLiteQueryBuilder();
        qry.setTables(queryInfo.getTables().get(0));

        String[] qryProjections = new String[((projection != null) ? projection.length : 0) + 1];
        qryProjections[0] = String.format("rowid as %s", _ID);
        if (projection != null)
            System.arraycopy(projection, 0, qryProjections, 1, projection.length);

        String[] qrySelectionArgs;
        if ((uriCode & ROW_MASK) == ROW_MASK) {
            qrySelectionArgs = new String[((selectionArgs != null) ? selectionArgs.length : 0) + 1];
            System.arraycopy(selectionArgs, 0, qrySelectionArgs, 1, selectionArgs.length);

            PrimaryKey primaryKey = new PrimaryKey(uri, queryInfo.getColumns().get(descriptor.getPrimaryKey().getField()).getFullFieldName()).invoke();
            qrySelectionArgs[0] = primaryKey.getIdValue();
            qry.appendWhere(String.format("%s = ?", primaryKey.getPrimaryKey()));
        } else
            qrySelectionArgs = selectionArgs;

        SQLiteDatabase rdb = this.dbHelper.getReadableDatabase();
        Cursor cursor = qry.query(rdb,
                qryProjections,
                selection,
                qrySelectionArgs,
                null,
                null,
                sortOrder,
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

    private static class PrimaryKey {
        private final Uri uri;
        private String idValue;
        private String primaryKey;

        public PrimaryKey(Uri uri, String primaryKey) {
            this.uri = uri;
            this.primaryKey = primaryKey;
        }

        public String getIdValue() {
            return this.idValue;
        }

        public String getPrimaryKey() {
            return this.primaryKey;
        }

        public PrimaryKey invoke() {
            this.idValue = this.uri.getLastPathSegment();
            Scanner sc = new Scanner(this.idValue);
            if (sc.hasNextInt())
                this.primaryKey = "ROWID";
            else {
                try {
                    this.idValue = StringUtils.UUIDToGUIDString(UUID.fromString(this.idValue));
                } catch (final Exception ignored) {
                }
            }
            return this;
        }
    }
}
