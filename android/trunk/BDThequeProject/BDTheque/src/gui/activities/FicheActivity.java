package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.gui.fragments.FicheFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;

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
            CommonBean bean = getIntent().getParcelableExtra("bean");

            ShowFragmentClass a = bean.getClass().getAnnotation(ShowFragmentClass.class);
            if (a == null) return;

            getFragmentManager().beginTransaction().add(android.R.id.content, FicheFragment.newInstance(a.value(), bean)).commit();

            // During initial setup, plug in the details fragments.
/*
            FicheFragment details = new FicheFragment();
            details.setArguments(getIntent().getExtras());
            getFragmentManager().beginTransaction().add(android.R.id.content, details).commit();
*/
        }
    }
}
