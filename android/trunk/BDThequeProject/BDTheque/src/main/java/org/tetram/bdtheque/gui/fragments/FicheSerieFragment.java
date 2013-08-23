package org.tetram.bdtheque.gui.fragments;


import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.viewpagerindicator.PageIndicator;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;
import org.tetram.bdtheque.gui.adapters.ViewPagerAdapter;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

@SuppressWarnings("UnusedDeclaration")
public class FicheSerieFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final CommonBean bean = getArguments().getParcelable(FicheFragment.BEAN);
        final SerieBean serieBean = BeanDao.getById(SerieBean.class, bean.getId());

        View view = inflater.inflate(R.layout.fiche_serie_fragment, container, false);

        //<editor-fold desc="Header">
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
        //</editor-fold>

        ViewPager tabsContent = (ViewPager) view.findViewById(android.R.id.tabcontent);

        List<ViewPagerAdapter.TabDescriptor> tabList = new ArrayList<ViewPagerAdapter.TabDescriptor>();

        tabList.add(new ViewPagerAdapter.TabDescriptor(
                getResources().getString(R.string.fiche_serie_tab_details),
                R.drawable.tab_icon_details,
                FicheFragment.newInstance(FicheSerieDetailsFragment.class, serieBean)
        ));

        if (!serieBean.getAlbums().isEmpty()) {
            tabList.add(new ViewPagerAdapter.TabDescriptor(
                    getResources().getString(R.string.fiche_serie_tab_albums),
                    R.drawable.tab_icon_albums,
                    FicheFragment.newInstance(FicheAlbumEditionsFragment.class, serieBean)
            ));
        }

        tabsContent.setAdapter(new ViewPagerAdapter(getFragmentManager(), tabList));

        View tabs = view.findViewById(android.R.id.tabs);
        PageIndicator pageIndicator = (PageIndicator) tabs;
        if (tabList.size() <= 1) tabs.setVisibility(View.GONE);
        pageIndicator.setViewPager(tabsContent, BDThequeApplication.getFicheSerieLastShownTab());
        pageIndicator.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i2) {

            }

            @Override
            public void onPageSelected(int i) {
                BDThequeApplication.setFicheSerieLastShownTab(i);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });

        return view;
    }

}
