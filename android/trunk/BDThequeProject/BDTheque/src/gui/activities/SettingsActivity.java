package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.os.Bundle;

import org.tetram.bdtheque.gui.activities.fragments.SettingsFragment;

public class SettingsActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getFragmentManager().beginTransaction()
                .replace(android.R.id.content, new SettingsFragment())
                .commit();
    }

}