package org.tetram.bdtheque.gui.fragments;


import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TabHost;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

@SuppressWarnings("UnusedDeclaration")
public class FicheSerieFragment extends FicheFragment {

    private static final String TAB_DETAILS = "details";
    private static final String TAB_ALBUMS = "albums";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable(FicheFragment.BEAN);
        final SerieBean serieBean = BeanDao.getById(SerieBean.class, bean.getId());

        View view = inflater.inflate(R.layout.fiche_serie_fragment, container, false);

        final ImageView imageView = (ImageView) view.findViewById(R.id.serie_notation);
        if (serieBean.getNotation() != null)
            imageView.setImageResource(serieBean.getNotation().getResDrawable());
        imageView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                NotationDialogFragment dialog = new NotationDialogFragment();
                Bundle args = new Bundle();
                args.putParcelable(FicheFragment.BEAN, bean);
                dialog.setArguments(args);
                dialog.show(getFragmentManager(), "NotationDialogFragment");
                return false;
            }
        });

        setUIElementURL(view, R.id.serie_titre, StringUtils.formatTitreAcceptNull(serieBean.getTitre()), serieBean.getSiteWeb(), 0);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();

        final TabHost tabHost = (TabHost) view.findViewById(android.R.id.tabhost);
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
            view.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        if (!"".equals(BDThequeApplication.getFicheSerieLastShownTab()))
            tabHost.setCurrentTabByTag(BDThequeApplication.getFicheSerieLastShownTab());
        tabHost.setOnTabChangedListener(new TabHost.OnTabChangeListener() {
            @Override
            public void onTabChanged(String tabId) {
                BDThequeApplication.setFicheSerieLastShownTab(tabHost.getCurrentTabTag());
            }
        });

        return view;
    }

}
