package org.tetram.bdtheque.data.utils;

import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.utils.StringUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class DaoUtils {

    private static final SimpleDateFormat simpleDateTimeFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.zzz");
    private static final SimpleDateFormat sqlDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.zzz");
    private static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd/yyyy");
    private static final SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");

    private DaoUtils() {
        super();
    }

    @Nullable
    public static UUID getFieldAsUUID(Cursor cursor, String fieldName) {
        String s = getFieldAsString(cursor, fieldName);
        return (s == null) ? null : StringUtils.GUIDStringToUUID(s);
    }

    @Nullable
    public static String getFieldAsString(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        return cursor.getString(columnIndex);
    }

    @Nullable
    public static Integer getFieldAsInteger(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_STRING:
                return Integer.valueOf(cursor.getString(columnIndex));
            default:
                return cursor.getInt(columnIndex);
        }
    }

    @Nullable
    public static Double getFieldAsDouble(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_STRING:
                return Double.valueOf(cursor.getString(columnIndex));
            default:
                return cursor.getDouble(columnIndex);
        }
    }

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    @Nullable
    public static Boolean getFieldAsBoolean(Cursor cursor, String fieldName) {
        Integer i = getFieldAsInteger(cursor, fieldName);
        if (i == null) return null;
        return (i != 0);
    }

    @Nullable
    public static Date getFieldAsDate(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_INTEGER:
                return new Date(cursor.getInt(columnIndex));
            case Cursor.FIELD_TYPE_STRING:
                try {
                    final String dateString = cursor.getString(columnIndex);
                    if (dateString.contains("/"))
                        return simpleDateFormat.parse(dateString);
                    else
                        return sqlDateFormat.parse(dateString);
                } catch (ParseException e) {
                    e.printStackTrace();
                    return null;
                }
            default:
                return null; // new Date(cursor.getDouble(columnIndex));
        }

    }

}
