package org.tetram.bdtheque.gui.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import java.util.List;

public class ViewPagerAdapter extends FragmentPagerAdapter {

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
    public int getCount() {
        return this.tabs.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return this.tabs.get(position).tabTitle;
    }

    public static class TabDescriptor {
        private final Fragment fragment;
        private final String tabTitle;

        public TabDescriptor(String tabTitle, Fragment fragment) {
            super();
            this.fragment = fragment;
            this.tabTitle = tabTitle;
        }

        public Fragment getFragment() {
            return this.fragment;
        }

        public String getTabTitle() {
            return this.tabTitle;
        }
    }
}
