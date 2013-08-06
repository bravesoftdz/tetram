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
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

public class FicheAlbumFragment extends FicheFragment {

    private static final String TAB_DETAILS = "details";
    private static final String TAB_EDITIONS = "editions";
    private static final String TAB_ALBUMS = "albums";
    private static final String TAB_IMAGES = "images";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable("bean");
        final AlbumBean albumBean = BeanDao.getById(AlbumBean.class, bean.getId());
        final SerieBean serieBean = albumBean.getSerie();

        View view = inflater.inflate(R.layout.fiche_album_fragment, container, false);

        final ImageView imageView = (ImageView) view.findViewById(R.id.album_notation);
        if (albumBean.getNotation() != null)
            imageView.setImageResource(albumBean.getNotation().getResDrawable());
        imageView.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                NotationDialogFragment dialog = new NotationDialogFragment();
                Bundle args = new Bundle();
                args.putParcelable("bean", bean);
                dialog.setArguments(args);
                dialog.show(getFragmentManager(), "NotationDialogFragment");
                return false;
            }
        });

        if (serieBean != null) {
            setUIElementURL(view, R.id.album_serie, StringUtils.formatTitreAcceptNull(serieBean.getTitre()), serieBean.getSiteWeb(), 0);
        } else {
            view.findViewById(R.id.fiche_album_row_serie).setVisibility(View.GONE);
        }
        setUIElement(view, R.id.album_titre, StringUtils.formatTitreAcceptNull(albumBean.getTitre()), R.id.fiche_album_row_titre);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();

        final TabHost tabHost = (TabHost) view.findViewById(android.R.id.tabhost);
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

            int nbImages = 0;
            for (EditionBean edition : albumBean.getEditions())
                nbImages += edition.getImages().size();
            if (nbImages > 0) {
                spec = tabHost.newTabSpec(TAB_IMAGES);
                spec.setIndicator(getResources().getString(R.string.fiche_album_tab_images));
                spec.setContent(R.id.tab_album_images);
                tabHost.addTab(spec);
                FicheAlbumImagesFragment imagesFragment = (FicheAlbumImagesFragment) FicheFragment.newInstance(FicheAlbumImagesFragment.class, albumBean);
                fragmentTransaction.replace(R.id.tab_album_images, imagesFragment);
            }
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
            view.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        if (!"".equals(BDThequeApplication.getFicheAlbumLastShownTab()))
            tabHost.setCurrentTabByTag(BDThequeApplication.getFicheAlbumLastShownTab());
        tabHost.setOnTabChangedListener(new TabHost.OnTabChangeListener() {
            @Override
            public void onTabChanged(String tabId) {
                BDThequeApplication.setFicheAlbumLastShownTab(tabHost.getCurrentTabTag());
            }
        });

        return view;
    }

}
