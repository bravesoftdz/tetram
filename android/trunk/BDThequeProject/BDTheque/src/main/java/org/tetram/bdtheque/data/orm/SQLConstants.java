package org.tetram.bdtheque.data.orm;

import java.text.SimpleDateFormat;

@SuppressWarnings("UnusedDeclaration")
public class SQLConstants {
    static final int MAX_SQL_ALIAS_LENGTH = 25;

    static final SimpleDateFormat simpleDateTimeFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.zzz");
    static final SimpleDateFormat sqlDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.zzz");
    static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd/yyyy");
    static final SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");

    private SQLConstants() {
        super();
    }
}
