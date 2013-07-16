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
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AlbumDao;

public class FicheAlbumFragment extends FicheFragment {

    private static final String TAB_DETAILS = "détails";
    private static final String TAB_EDITIONS = "éditions";
    private static final String TAB_ALBUMS = "albums";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable("bean");
        final AlbumDao dao = new AlbumDao(getActivity());
        final AlbumBean album = dao.getById(bean.getId());
        final SerieBean serie = album.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_fragment, container, false);

        final TabHost tabHost = (TabHost) v.findViewById(android.R.id.tabhost);
        tabHost.setup();

        TabHost.TabSpec spec;

        spec = tabHost.newTabSpec(TAB_DETAILS);
        spec.setIndicator(getResources().getString(R.string.fiche_album_tab_details));
        spec.setContent(R.id.tab_album_detail);
        tabHost.addTab(spec);

        if (!album.getEditions().isEmpty()) {
            spec = tabHost.newTabSpec(TAB_EDITIONS);
            spec.setIndicator(getResources().getQuantityString(R.plurals.fiche_album_tab_editions, album.getEditions().size()));
            spec.setContent(R.id.tab_album_editions);
            tabHost.addTab(spec);
        }

        if ((serie != null) && (serie.getAlbums().size() > 1)) {
            spec = tabHost.newTabSpec(TAB_ALBUMS);
            spec.setIndicator(getResources().getString(R.string.fiche_album_tab_albums));
            spec.setContent(R.id.tab_album_albums);
            tabHost.addTab(spec);
        }

        if (tabHost.getTabWidget().getTabCount() <= 1)
            v.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        if (!"".equals(BDThequeApplication.getFicheAlbumLastShownTab()))
            tabHost.setCurrentTabByTag(BDThequeApplication.getFicheAlbumLastShownTab());
        tabHost.setOnTabChangedListener(new TabHost.OnTabChangeListener() {
            @Override
            public void onTabChanged(String tabId) {
                BDThequeApplication.setFicheAlbumLastShownTab(tabHost.getCurrentTabTag());
            }
        });

        // TODO: à voir s'il faut optimiser pour charger les fragments uniquement s'ils seront affichables (= que le tab associé est accessible)
        FicheAlbumDetailsFragment detailFragment = (FicheAlbumDetailsFragment) FicheFragment.newInstance(FicheAlbumDetailsFragment.class, album);
        FicheAlbumEditionsFragment editionsFragment = (FicheAlbumEditionsFragment) FicheFragment.newInstance(FicheAlbumEditionsFragment.class, album);
        FicheAlbumAlbumsFragment albumsFragment = (FicheAlbumAlbumsFragment) FicheFragment.newInstance(FicheAlbumAlbumsFragment.class, album);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.tab_album_detail, detailFragment);
        fragmentTransaction.replace(R.id.tab_album_editions, editionsFragment);
        fragmentTransaction.replace(R.id.tab_album_albums, albumsFragment);
        fragmentTransaction.commit();

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
