package org.tetram.bdtheque;

import android.app.Application;

@SuppressWarnings("ClassNamePrefixedWithPackageName")
public class BDThequeApplication extends Application {
    private static BDThequeApplication ourInstance;

    public static BDThequeApplication getInstance() {
        return ourInstance;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        ourInstance = this;
    }
}
