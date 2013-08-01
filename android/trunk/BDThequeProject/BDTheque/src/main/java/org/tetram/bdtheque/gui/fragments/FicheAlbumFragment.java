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
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.dao.AlbumDao;

public class FicheAlbumFragment extends FicheFragment {

    private static final String TAB_DETAILS = "détails";
    private static final String TAB_EDITIONS = "éditions";
    private static final String TAB_ALBUMS = "albums";
    private static final String TAB_IMAGES = "images";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable("bean");
        final AlbumDao dao = new AlbumDao(getActivity());
        final AlbumBean albumBean = dao.getById(bean.getId());
        final SerieBean serieBean = albumBean.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_fragment, container, false);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();

        final TabHost tabHost = (TabHost) v.findViewById(android.R.id.tabhost);
        tabHost.setup();

        TabHost.TabSpec spec;

        spec = tabHost.newTabSpec(TAB_DETAILS);
        spec.setIndicator(getResources().getString(R.string.fiche_album_tab_details));
        spec.setContent(R.id.tab_album_details);
        tabHost.addTab(spec);
        FicheAlbumDetailsFragment detailFragment = (FicheAlbumDetailsFragment) FicheFragment.newInstance(FicheAlbumDetailsFragment.class, albumBean);
        fragmentTransaction.replace(R.id.tab_album_details, detailFragment);

        if (!albumBean.getEditions().isEmpty()) {
            spec = tabHost.newTabSpec(TAB_EDITIONS);
            spec.setIndicator(getResources().getQuantityString(R.plurals.fiche_album_tab_editions, albumBean.getEditions().size()));
            spec.setContent(R.id.tab_album_editions);
            tabHost.addTab(spec);
            FicheAlbumEditionsFragment editionsFragment = (FicheAlbumEditionsFragment) FicheFragment.newInstance(FicheAlbumEditionsFragment.class, albumBean);
            fragmentTransaction.replace(R.id.tab_album_editions, editionsFragment);

            spec = tabHost.newTabSpec(TAB_IMAGES);
            spec.setIndicator(getResources().getString(R.string.fiche_album_tab_images));
            spec.setContent(R.id.tab_album_images);
            tabHost.addTab(spec);
            FicheAlbumImagesFragment imagesFragment = (FicheAlbumImagesFragment) FicheFragment.newInstance(FicheAlbumImagesFragment.class, albumBean);
            fragmentTransaction.replace(R.id.tab_album_images, imagesFragment);
        }

        if ((serieBean != null) && (serieBean.getAlbums().size() > 1)) {
            spec = tabHost.newTabSpec(TAB_ALBUMS);
            spec.setIndicator(getResources().getString(R.string.fiche_serie_tab_albums));
            spec.setContent(R.id.tab_album_albums);
            tabHost.addTab(spec);
            FicheSerieAlbumsFragment albumsFragment = (FicheSerieAlbumsFragment) FicheFragment.newInstance(FicheSerieAlbumsFragment.class, albumBean);
            fragmentTransaction.replace(R.id.tab_album_albums, albumsFragment);
        }

        fragmentTransaction.commit();

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
