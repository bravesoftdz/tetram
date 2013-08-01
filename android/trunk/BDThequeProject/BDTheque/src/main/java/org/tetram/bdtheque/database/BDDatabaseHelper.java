package org.tetram.bdtheque.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
import android.widget.Toast;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.BuildConfig;
import org.tetram.bdtheque.R;

import java.io.IOException;

public class BDDatabaseHelper extends SQLiteOpenHelper {

    static final String LOG_TAG = "BDThequeDatabaseHelper";

    private static final String DATABASE_NAME = "bdtheque";
    private static final int DATABASE_VERSION = 2;

    private final Context context;

    public BDDatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        this.context = context;
    }

    private void runSQL(SQLiteDatabase db, String scriptName) {
        try {
            DBUtils.executeSqlScript(this.context, db, scriptName);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /*
     * Called when the org.tetram.bdtheque.database is created for the first time. This is where the
     * creation of tables and the initial population of the tables should happen.
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        runSQL(db, "sql/create_db.sql");
        onUpgrade(db, 0, DATABASE_VERSION);
    }

    /*
     * Called when the org.tetram.bdtheque.database needs to be upgraded. The implementation
     * should use this method to drop tables, add tables, or do anything else it
     * needs to upgrade to the new schema version.
     * This method executes within a transaction.  If an exception is thrown, all changes
     * will automatically be rolled back.
     */
    @Override
    public void onUpgrade(final SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.w(LOG_TAG, "Upgrading org.tetram.bdtheque.database from version " + oldVersion + " to " + newVersion + ".");

        switch (oldVersion) {
            case 0:
            case 1:
                if (BuildConfig.DEBUG) {
                    Toast.makeText(BDThequeApplication.getInstance().getApplicationContext(), this.context.getString(R.string.msg_chargement_donnees), Toast.LENGTH_LONG).show();
                    runSQL(db, "sql/init_editeurs.sql");
                    runSQL(db, "sql/init_collections.sql");
                    runSQL(db, "sql/init_series.sql");
                    runSQL(db, "sql/init_albums.sql");
                    runSQL(db, "sql/init_editions.sql");
                    runSQL(db, "sql/init_personnes.sql");
                    runSQL(db, "sql/init_auteurs.sql");
                    runSQL(db, "sql/init_auteurs_series.sql");
                    runSQL(db, "sql/init_genres.sql");
                    runSQL(db, "sql/init_genres_series.sql");
                    runSQL(db, "sql/init_listes.sql");
                    runSQL(db, "sql/init_couvertures.sql");
                }
//            case 2:
//                runSQL(db, "sql/upgrade_to_v3.sql");
            default: {

            }
        }

    }
}
