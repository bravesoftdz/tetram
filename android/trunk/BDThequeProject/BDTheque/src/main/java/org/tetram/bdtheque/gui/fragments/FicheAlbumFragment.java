package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.gui.adapters.ViewPagerAdapter;

import java.util.ArrayList;
import java.util.List;

public class FicheAlbumFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable("bean");
        final AlbumDao dao = new AlbumDao(getActivity());
        final AlbumBean albumBean = dao.getById(bean.getId());
        final SerieBean serieBean = albumBean.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_fragment, container, false);
        final ViewPager viewPager = (ViewPager) v.findViewById(android.R.id.tabhost);

        List<ViewPagerAdapter.TabDescriptor> tabs = new ArrayList<ViewPagerAdapter.TabDescriptor>();

        tabs.add(new ViewPagerAdapter.TabDescriptor(
                getResources().getString(R.string.fiche_album_tab_details),
                FicheFragment.newInstance(FicheAlbumDetailsFragment.class, albumBean))
        );

        if (!albumBean.getEditions().isEmpty()) {
            tabs.add(new ViewPagerAdapter.TabDescriptor(
                    getResources().getQuantityString(R.plurals.fiche_album_tab_editions, albumBean.getEditions().size()),
                    FicheFragment.newInstance(FicheAlbumEditionsFragment.class, albumBean))
            );

            tabs.add(new ViewPagerAdapter.TabDescriptor(
                    getResources().getString(R.string.fiche_album_tab_images),
                    FicheFragment.newInstance(FicheAlbumImagesFragment.class, albumBean))
            );
        }

        if ((serieBean != null) && (serieBean.getAlbums().size() > 1)) {
            tabs.add(new ViewPagerAdapter.TabDescriptor(
                    getResources().getString(R.string.fiche_serie_tab_albums),
                    FicheFragment.newInstance(FicheSerieAlbumsFragment.class, albumBean))
            );
        }

        viewPager.setAdapter(new ViewPagerAdapter(getChildFragmentManager(), tabs));

        if (tabs.size() <= 1)
            v.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        viewPager.setCurrentItem(BDThequeApplication.getFicheAlbumLastShownTab());

        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                BDThequeApplication.setFicheAlbumLastShownTab(position);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        return v;
    }

}
