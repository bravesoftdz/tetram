package org.tetram.bdtheque.gui.activities;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.gui.fragments.FicheFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;

public class FicheActivity extends FragmentActivity {

    @SuppressWarnings("VariableNotUsedInsideIf")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (BDThequeApplication.getInstance().isRepertoireDualPanel()) {
            // si l'écran est assez large, la fiche est affichée en mode DualPanel
            finish();
            return;
        }

        getActionBar().setDisplayHomeAsUpEnabled(true);

        if (savedInstanceState == null) {
            CommonBean bean = getIntent().getParcelableExtra(FicheFragment.BEAN);

            ShowFragmentClass a = bean.getClass().getAnnotation(ShowFragmentClass.class);
            if (a == null) return;

            getSupportFragmentManager().beginTransaction().add(android.R.id.content, FicheFragment.newInstance(a.value(), bean)).commit();
        }
    }
}
