package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.viewpagerindicator.PageIndicator;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.BeanDao;
import org.tetram.bdtheque.gui.adapters.ViewPagerAdapter;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;
import java.util.List;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

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

        View view = inflater.inflate(R.layout.fiche_personne_fragment, container, false);

        //<editor-fold desc="Header">
        setUIElement(view, R.id.personne_nom, StringUtils.formatTitre(personneBean.getNom()));
        //</editor-fold>

        ViewPager tabsContent = (ViewPager) view.findViewById(android.R.id.tabcontent);

        List<ViewPagerAdapter.TabDescriptor> tabList = new ArrayList<ViewPagerAdapter.TabDescriptor>();

        if ((personneBean.getBiographie() != null) && !personneBean.getBiographie().isEmpty())
            tabList.add(new ViewPagerAdapter.TabDescriptor(
                    getResources().getString(R.string.fiche_personne_tab_details),
                    R.drawable.tab_icon_details,
                    FicheFragment.newInstance(FichePersonneDetailsFragment.class, personneBean)
            ));

        tabList.add(new ViewPagerAdapter.TabDescriptor(
                getResources().getString(R.string.fiche_personne_tab_bibliographie),
                R.drawable.tab_icon_albums,
                FicheFragment.newInstance(FichePersonneBibliographieFragment.class, personneBean)
        ));

        tabsContent.setAdapter(new ViewPagerAdapter(getFragmentManager(), tabList));

        View tabs = view.findViewById(android.R.id.tabs);
        PageIndicator pageIndicator = (PageIndicator) tabs;
        if (tabList.size() <= 1) tabs.setVisibility(View.GONE);
        pageIndicator.setViewPager(tabsContent, BDThequeApplication.getFichePersonneLastShownTab());
        pageIndicator.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i2) {

            }

            @Override
            public void onPageSelected(int i) {
                BDThequeApplication.setFichePersonneLastShownTab(i);
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });

        return view;
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
