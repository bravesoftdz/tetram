package org.tetram.bdtheque;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.preference.PreferenceManager;

import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;

import org.tetram.bdtheque.utils.UserConfig;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class BDThequeApplication extends Application {
    private static BDThequeApplication ourInstance;

    private static int ficheAlbumLastShownTab;
    private static int ficheSerieLastShownTab;
    private static int fichePersonneLastShownTab;

    @Override
    public void onCreate() {
        super.onCreate();
        ourInstance = this;
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        prefs.edit().putString(getString(R.string.pref_symboleMonetaire), UserConfig.getInstance().getSymboleMonetaire()).commit();
        PreferenceManager.setDefaultValues(this, R.xml.preferences, false);
        initImageLoader(getApplicationContext());
    }

    public static BDThequeApplication getInstance() {
        return ourInstance;
    }

    public boolean isRepertoireDualPanel() {
        final Configuration configuration = getResources().getConfiguration();
        return (configuration.orientation == Configuration.ORIENTATION_LANDSCAPE) && (configuration.screenWidthDp >= 650);
    }

    public static int getFicheAlbumLastShownTab() {
        return ficheAlbumLastShownTab;
    }

    public static void setFicheAlbumLastShownTab(int tabPosition) {
        BDThequeApplication.ficheAlbumLastShownTab = tabPosition;
    }

    public static int getFicheSerieLastShownTab() {
        return ficheSerieLastShownTab;
    }

    public static void setFicheSerieLastShownTab(int tabPosition) {
        BDThequeApplication.ficheSerieLastShownTab = tabPosition;
    }

    public static int getFichePersonneLastShownTab() {
        return fichePersonneLastShownTab;
    }

    public static void setFichePersonneLastShownTab(int tabPosition) {
        BDThequeApplication.fichePersonneLastShownTab = tabPosition;
    }

    private static void initImageLoader(Context context) {
        // This configuration tuning is custom. You can tune every option, you may tune some of them,
        // or you can create default configuration by
        //  ImageLoaderConfiguration.createDefault(this);
        // method.
        ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(context)
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .discCacheFileNameGenerator(new Md5FileNameGenerator())
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .build();
        // Initialize ImageLoader with configuration.
        ImageLoader.getInstance().init(config);
    }
}