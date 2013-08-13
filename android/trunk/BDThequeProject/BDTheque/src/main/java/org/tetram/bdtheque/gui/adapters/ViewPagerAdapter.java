package org.tetram.bdtheque.gui.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.viewpagerindicator.IconPagerAdapter;

import java.util.List;

public class ViewPagerAdapter extends FragmentPagerAdapter implements IconPagerAdapter {

    private final List<TabDescriptor> tabs;

    public ViewPagerAdapter(FragmentManager fm, List<TabDescriptor> tabs) {
        super(fm);
        this.tabs = tabs;
    }

    @Override
    public Fragment getItem(int position) {
        return this.tabs.get(position).fragment;
    }

    @Override
    public int getIconResId(int index) {
        return this.tabs.get(index).getIconResId();
    }

    @Override
    public int getCount() {
        return this.tabs.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return this.tabs.get(position).tabTitle;
    }

    @SuppressWarnings("UnusedDeclaration")
    public static class TabDescriptor {
        private final int iconResId;
        private final Fragment fragment;
        private final String tabTitle;

        public TabDescriptor(String tabTitle, Fragment fragment) {
            this(tabTitle, -1, fragment);
        }

        public TabDescriptor(String tabTitle, int iconResId, Fragment fragment) {
            super();
            this.iconResId = iconResId;
            this.fragment = fragment;
            this.tabTitle = tabTitle;
        }

        public Fragment getFragment() {
            return this.fragment;
        }

        public String getTabTitle() {
            return this.tabTitle;
        }

        public int getIconResId() {
            return this.iconResId;
        }
    }
}
