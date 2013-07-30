package org.tetram.bdtheque.gui.activities;

import android.app.Activity;
import android.os.Bundle;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.gui.fragments.FicheFragment;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;

public class FicheActivity extends Activity {

    @SuppressWarnings("VariableNotUsedInsideIf")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (BDThequeApplication.getInstance().isRepertoireDualPanel()) {
            // si l'écran est assez large, la fiche est affichée en mode DualPanel
            finish();
            return;
        }

        if (savedInstanceState == null) {
            CommonBean bean = getIntent().getParcelableExtra("bean");

            ShowFragmentClass a = bean.getClass().getAnnotation(ShowFragmentClass.class);
            if (a == null) return;

            getFragmentManager().beginTransaction().add(android.R.id.content, FicheFragment.newInstance(a.value(), bean)).commit();
        }
    }
}
