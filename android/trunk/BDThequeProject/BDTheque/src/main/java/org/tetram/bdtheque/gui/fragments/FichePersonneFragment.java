package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TabHost;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;

@SuppressWarnings("UnusedDeclaration")
public class FichePersonneFragment extends FicheFragment {

    private static final String TAB_BIBLIOGRAPHIE = "bibliographie";
    private static final String TAB_DETAILS = "details";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable(FicheFragment.BEAN);
        final PersonneBean personneBean = BeanDao.getById(PersonneBean.class, bean.getId());

        View v = inflater.inflate(R.layout.fiche_personne_fragment, container, false);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();

        final TabHost tabHost = (TabHost) v.findViewById(android.R.id.tabhost);
        tabHost.setup();

        TabHost.TabSpec spec;

        spec = tabHost.newTabSpec(TAB_DETAILS);
        spec.setIndicator(getResources().getString(R.string.fiche_personne_tab_details));
        spec.setContent(R.id.tab_personne_details);
        tabHost.addTab(spec);
        FichePersonneDetailsFragment detailFragment = (FichePersonneDetailsFragment) FicheFragment.newInstance(FichePersonneDetailsFragment.class, personneBean);
        fragmentTransaction.replace(R.id.tab_personne_details, detailFragment);

        spec = tabHost.newTabSpec(TAB_BIBLIOGRAPHIE);
        spec.setIndicator(getResources().getString(R.string.fiche_personne_tab_bibliographie));
        spec.setContent(R.id.tab_personne_bibliographie);
        tabHost.addTab(spec);
        FichePersonneBibliographieFragment bibliographieFragment = (FichePersonneBibliographieFragment) FicheFragment.newInstance(FichePersonneBibliographieFragment.class, personneBean);
        fragmentTransaction.replace(R.id.tab_personne_bibliographie, bibliographieFragment);

        fragmentTransaction.commit();

        if (tabHost.getTabWidget().getTabCount() <= 1)
            v.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        if (!"".equals(BDThequeApplication.getFichePersonneLastShownTab()))
            tabHost.setCurrentTabByTag(BDThequeApplication.getFichePersonneLastShownTab());
        tabHost.setOnTabChangedListener(new TabHost.OnTabChangeListener() {
            @Override
            public void onTabChanged(String tabId) {
                BDThequeApplication.setFichePersonneLastShownTab(tabHost.getCurrentTabTag());
            }
        });

        return v;
    }

/*
    private View createTabView(final String text, final int id) {
        View view = LayoutInflater.from(this).inflate(R.layout.tabs_icon, null);
        ImageView imageView = (ImageView) view.findViewById(R.id.tab_icon);
        imageView.setImageDrawable(getResources().getDrawable(id));
        ((TextView) view.findViewById(R.id.tab_text)).setText(text);
        return view;
    }
*/
}
