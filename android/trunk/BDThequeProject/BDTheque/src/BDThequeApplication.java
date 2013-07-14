package org.tetram.bdtheque;

import android.app.Application;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import org.tetram.bdtheque.utils.UserConfig;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class BDThequeApplication extends Application {
    private static BDThequeApplication ourInstance;
    private static int ficheAlbumLastShownTab;

    public static BDThequeApplication getInstance() {
        return ourInstance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        ourInstance = this;
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        prefs.edit().putString(getString(R.string.pref_symboleMonetaire), UserConfig.getInstance().getSymboleMonetaire()).commit();
    }

    public static int getFicheAlbumLastShownTab() {
        return ficheAlbumLastShownTab;
    }

    public static void setFicheAlbumLastShownTab(int tabPosition) {
        BDThequeApplication.ficheAlbumLastShownTab = tabPosition;
    }
}
