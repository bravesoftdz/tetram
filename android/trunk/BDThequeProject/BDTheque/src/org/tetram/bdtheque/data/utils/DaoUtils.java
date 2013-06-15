package org.tetram.bdtheque.data.utils;

import android.database.Cursor;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.UUID;

public abstract class DaoUtils {

    private DaoUtils() {
    }

    public static UUID getFieldUUID(Cursor cursor, String fieldName) {
        String s = getFieldString(cursor, fieldName);
        return s == null ? null : StringUtils.GUIDStringToUUID(s);
    }

    public static String getFieldString(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        return cursor.isNull(columnIndex) ? null : cursor.getString(columnIndex);
    }

    public static Integer getFieldInteger(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        return cursor.isNull(columnIndex) ? null : cursor.getInt(columnIndex);
    }

    public static Boolean getFieldBoolean(Cursor cursor, String fieldName) {
        Integer i = getFieldInteger(cursor, fieldName);
        if (i == null) return null;
        return (i != 0);
    }

}
