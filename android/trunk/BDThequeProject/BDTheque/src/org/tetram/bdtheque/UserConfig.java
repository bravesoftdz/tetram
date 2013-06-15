package org.tetram.bdtheque;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class UserConfig {
    private static UserConfig ourInstance = new UserConfig();

    public static UserConfig getInstance() {
        return ourInstance;
    }

    private UserConfig() {
    }

    private int formatTitreAlbum = 0;
    private boolean afficheNoteListes = true;

    public void reloadConfig(Context context) {
        SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(context);
        this.formatTitreAlbum = Integer.valueOf(sharedPref.getString(context.getString(R.string.pref_formatTitreAlbum), "0"));
        this.afficheNoteListes = sharedPref.getBoolean(context.getString(R.string.pref_notationListe), true);
    }

    public int getFormatTitreAlbum() {
        return formatTitreAlbum;
    }

    public boolean getAfficheNoteListes() {
        return afficheNoteListes;
    }
}
