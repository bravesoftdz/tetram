package org.tetram.bdtheque.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import org.tetram.bdtheque.R;

public class UserConfig {
    private static final UserConfig ourInstance = new UserConfig();

    public static UserConfig getInstance() {
        return ourInstance;
    }

    private UserConfig() {
        super();
    }

    @SuppressWarnings("RedundantFieldInitialization")
    private int formatTitreAlbum = 0;
    private boolean afficheNoteListes = true;

    public void reloadConfig(final Context context) {
        final SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(context);
        this.formatTitreAlbum = Integer.valueOf(sharedPref.getString(context.getString(R.string.pref_formatTitreAlbum), "0"));
        this.afficheNoteListes = sharedPref.getBoolean(context.getString(R.string.pref_notationListe), true);
    }

    public int getFormatTitreAlbum() {
        return this.formatTitreAlbum;
    }

    public boolean shouldAfficheNoteListes() {
        return this.afficheNoteListes;
    }
}
