package org.tetram.bdtheque.data.orm;

import java.text.SimpleDateFormat;
import java.util.Locale;

@SuppressWarnings("UnusedDeclaration")
public class SQLConstants {
    static final int MAX_SQL_ALIAS_LENGTH = 25;

    // ces constantes ne sont pas destinées à l'affichage mais au traitement des données
    static final SimpleDateFormat simpleDateTimeFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.zzz", Locale.US);
    static final SimpleDateFormat sqlDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.zzz", Locale.US);
    static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd/yyyy", Locale.US);
    static final SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.US);

    private SQLConstants() {
        super();
    }
}
