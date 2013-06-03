package org.tetram.bdtheque.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.io.IOException;

/**
 * Created by Thierry on 02/06/13.
 */
public class DatabaseHelper extends SQLiteOpenHelper {

    static final String TAG = "BDThequeDatabaseHelper";

    private static final String DATABASE_NAME = "bdtheque";
    private static final int DATABASE_VERSION = 0;

    private Context context;

    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;
    }

    private void RunSQL(SQLiteDatabase db, String scriptName) {
        try {
            DBUtils.executeSqlScript(context, db, scriptName);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*
     * Called when the database is created for the first time. This is where the
     * creation of tables and the initial population of the tables should happen.
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        RunSQL(db, "sql/create_db.sql");
    }

    /*
     * Called when the database needs to be upgraded. The implementation
     * should use this method to drop tables, add tables, or do anything else it
     * needs to upgrade to the new schema version.
     * This method executes within a transaction.  If an exception is thrown, all changes
     * will automatically be rolled back.
     */
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.w(TAG, "Upgrading database from version " + oldVersion + " to "
                + newVersion + ".");

        switch (oldVersion) {
            case 0:
                RunSQL(db, "sql/upgrade_to_v1.sql");
            case 1:
                RunSQL(db, "sql/upgrade_to_v2.sql");
            default: {

            }
        }

    }
}
