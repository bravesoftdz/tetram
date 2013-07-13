package org.tetram.bdtheque;

import android.app.Application;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class BDThequeApplication extends Application {
    private static BDThequeApplication ourInstance;
    private static int ficheAlbumLastShownTab;

    public static BDThequeApplication getInstance() {
        return ourInstance;
    }

    public static int getFicheAlbumLastShownTab() {
        return ficheAlbumLastShownTab;
    }

    public static void setFicheAlbumLastShownTab(int tabPosition) {
        BDThequeApplication.ficheAlbumLastShownTab = tabPosition;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        ourInstance = this;
    }
}
