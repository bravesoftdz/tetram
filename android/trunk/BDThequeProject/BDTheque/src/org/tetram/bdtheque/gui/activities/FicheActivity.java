package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;

import org.tetram.bdtheque.gui.activities.fragments.FicheFragment;

public class FicheActivity extends Activity {

    @SuppressWarnings("VariableNotUsedInsideIf")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            // If the screen is now in landscape mode, we can show the
            // dialog in-line with the list so we don't need this activity.
            finish();
            return;
        }

        if (savedInstanceState == null) {
            // During initial setup, plug in the details fragments.
            FicheFragment details = new FicheFragment();
            details.setArguments(getIntent().getExtras());
            getFragmentManager().beginTransaction().add(android.R.id.content, details).commit();
        }
    }
}
