package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.viewpagerindicator.PageIndicator;
import com.viewpagerindicator.TabPageIndicator;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;
import org.tetram.bdtheque.gui.adapters.ViewPagerAdapter;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.gui.adapters.ViewPagerAdapter.TabDescriptor;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

public class FicheAlbumFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable(FicheFragment.BEAN);
        final AlbumBean albumBean = BeanDao.getById(AlbumBean.class, bean.getId());
        final SerieBean serieBean = albumBean.getSerie();

        View view = inflater.inflate(R.layout.fiche_album_fragment, container, false);

        //<editor-fold desc="Header">
        final ImageView imageView = (ImageView) view.findViewById(R.id.album_notation);
        if (albumBean.getNotation() != null)
            imageView.setImageResource(albumBean.getNotation().getResDrawable());
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

        if (serieBean != null) {
            setUIElementURL(view, R.id.album_serie, StringUtils.formatTitreAcceptNull(serieBean.getTitre()), serieBean.getSiteWeb(), 0);
        } else {
            view.findViewById(R.id.fiche_album_row_serie).setVisibility(View.GONE);
        }
        setUIElement(view, R.id.album_titre, StringUtils.formatTitreAcceptNull(albumBean.getTitre()), R.id.fiche_album_row_titre);
        //</editor-fold>

        ViewPager tabsContent = (ViewPager) view.findViewById(android.R.id.tabcontent);

        List<TabDescriptor> tabList = new ArrayList<TabDescriptor>();

        tabList.add(new TabDescriptor(
                getResources().getString(R.string.fiche_album_tab_details),
                R.drawable.tab_icon_details,
                FicheFragment.newInstance(FicheAlbumDetailsFragment.class, albumBean)
        ));

        if (!albumBean.getEditions().isEmpty()) {
            tabList.add(new TabDescriptor(
                    getResources().getQuantityString(R.plurals.fiche_album_tab_editions, albumBean.getEditions().size()),
                    R.drawable.tab_icon_editions,
                    FicheFragment.newInstance(FicheAlbumEditionsFragment.class, albumBean)
            ));

            int nbImages = 0;
            for (EditionBean edition : albumBean.getEditions())
                nbImages += edition.getImages().size();
            if (nbImages > 0) {
                tabList.add(new TabDescriptor(
                        getResources().getQuantityString(R.plurals.fiche_album_tab_images, nbImages),
                        R.drawable.tab_icon_images,
                        FicheFragment.newInstance(FicheAlbumImagesFragment.class, albumBean)
                ));
            }
        }

        if ((serieBean != null) && (serieBean.getAlbums().size() > 1)) {
            tabList.add(new TabDescriptor(
                    getResources().getString(R.string.fiche_serie_tab_albums),
                    R.drawable.tab_icon_albums,
                    FicheFragment.newInstance(FicheSerieAlbumsFragment.class, albumBean)
            ));
        }

        tabsContent.setAdapter(new ViewPagerAdapter(getFragmentManager(), tabList));

        View tabs = view.findViewById(android.R.id.tabs);
        PageIndicator pageIndicator = (PageIndicator) tabs;
        if (tabList.size() <= 1) tabs.setVisibility(View.GONE);
        pageIndicator.setViewPager(tabsContent, BDThequeApplication.getFicheAlbumLastShownTab());
        pageIndicator.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i2) {

            }

            @Override
            public void onPageSelected(int i) {
                BDThequeApplication.setFicheAlbumLastShownTab(i);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });

        return view;
    }

}
