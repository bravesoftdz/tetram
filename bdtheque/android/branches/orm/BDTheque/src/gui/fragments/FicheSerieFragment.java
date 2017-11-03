package org.tetram.bdtheque.gui.fragments;

import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TabHost;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.SerieDao;

@SuppressWarnings("UnusedDeclaration")
public class FicheSerieFragment extends FicheFragment {

    private static final String TAB_DETAILS = "détails";
    private static final String TAB_ALBUMS = "albums";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable("bean");
        final SerieDao dao = new SerieDao(getActivity());
        final SerieBean serieBean = dao.getById(bean.getId());

        View v = inflater.inflate(R.layout.fiche_serie_fragment, container, false);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();

        final TabHost tabHost = (TabHost) v.findViewById(android.R.id.tabhost);
        tabHost.setup();

        TabHost.TabSpec spec;

        spec = tabHost.newTabSpec(TAB_DETAILS);
        spec.setIndicator(getResources().getString(R.string.fiche_serie_tab_details));
        spec.setContent(R.id.tab_serie_details);
        tabHost.addTab(spec);
        FicheSerieDetailsFragment detailFragment = (FicheSerieDetailsFragment) FicheFragment.newInstance(FicheSerieDetailsFragment.class, serieBean);
        fragmentTransaction.replace(R.id.tab_serie_details, detailFragment);

        if (!serieBean.getAlbums().isEmpty()) {
            spec = tabHost.newTabSpec(TAB_ALBUMS);
            spec.setIndicator(getResources().getString(R.string.fiche_serie_tab_albums));
            spec.setContent(R.id.tab_serie_albums);
            tabHost.addTab(spec);
            FicheSerieAlbumsFragment albumsFragment = (FicheSerieAlbumsFragment) FicheFragment.newInstance(FicheSerieAlbumsFragment.class, serieBean);
            fragmentTransaction.replace(R.id.tab_serie_albums, albumsFragment);
        }

        fragmentTransaction.commit();

        if (tabHost.getTabWidget().getTabCount() <= 1)
            v.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        if (!"".equals(BDThequeApplication.getFicheSerieLastShownTab()))
            tabHost.setCurrentTabByTag(BDThequeApplication.getFicheSerieLastShownTab());
        tabHost.setOnTabChangedListener(new TabHost.OnTabChangeListener() {
            @Override
            public void onTabChanged(String tabId) {
                BDThequeApplication.setFicheSerieLastShownTab(tabHost.getCurrentTabTag());
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
