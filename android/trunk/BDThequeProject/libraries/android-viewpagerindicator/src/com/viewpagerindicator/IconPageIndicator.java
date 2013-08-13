/*
 * Copyright (C) 2011 The Android Open Source Project
 * Copyright (C) 2012 Jake Wharton
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.viewpagerindicator;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

/**
 * This widget implements the dynamic action bar tab behavior that can change
 * across different configurations or circumstances.
 */
@SuppressWarnings("UnusedDeclaration")
@TargetApi(Build.VERSION_CODES.CUPCAKE)
public class IconPageIndicator extends HorizontalScrollView implements PageIndicator {
    private final IcsLinearLayout mIconsLayout;
    private final OnClickListener mIconClickListener = new OnClickListener() {
        @Override
        public void onClick(View v) {
            IconView imageView = (IconView) v;
            final int oldSelected = IconPageIndicator.this.mViewPager.getCurrentItem();
            final int newSelected = imageView.getIndex();
            IconPageIndicator.this.mViewPager.setCurrentItem(newSelected);
            if ((oldSelected == newSelected) && (IconPageIndicator.this.iconReselectedListener != null)) {
                IconPageIndicator.this.iconReselectedListener.onIconReselected(newSelected);
            }
        }
    };
    private ViewPager mViewPager;
    private OnPageChangeListener mListener;
    private Runnable mIconSelector;
    private int mSelectedIndex;
    private OnIconReselectedListener iconReselectedListener;

    public IconPageIndicator(Context context) {
        this(context, null);
    }

    public IconPageIndicator(Context context, AttributeSet attrs) {
        super(context, attrs);
        setHorizontalScrollBarEnabled(false);

        this.mIconsLayout = new IcsLinearLayout(context, R.attr.vpiIconPageIndicatorStyle);
        addView(this.mIconsLayout, new LayoutParams(WRAP_CONTENT, MATCH_PARENT, Gravity.CENTER));
    }

    private void animateToIcon(final int position) {
        final View iconView = this.mIconsLayout.getChildAt(position);
        if (this.mIconSelector != null) {
            removeCallbacks(this.mIconSelector);
        }
        this.mIconSelector = new Runnable() {
            @Override
            public void run() {
                final int scrollPos = iconView.getLeft() - ((getWidth() - iconView.getWidth()) / 2);
                smoothScrollTo(scrollPos, 0);
                IconPageIndicator.this.mIconSelector = null;
            }
        };
        post(this.mIconSelector);
    }

    @Override
    public void onAttachedToWindow() {
        super.onAttachedToWindow();
        if (this.mIconSelector != null) {
            // Re-post the selector we saved
            post(this.mIconSelector);
        }
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if (this.mIconSelector != null) {
            removeCallbacks(this.mIconSelector);
        }
    }

    @Override
    public void onPageScrollStateChanged(int arg0) {
        if (this.mListener != null) {
            this.mListener.onPageScrollStateChanged(arg0);
        }
    }

    @Override
    public void onPageScrolled(int arg0, float arg1, int arg2) {
        if (this.mListener != null) {
            this.mListener.onPageScrolled(arg0, arg1, arg2);
        }
    }

    @Override
    public void onPageSelected(int arg0) {
        setCurrentItem(arg0);
        if (this.mListener != null) {
            this.mListener.onPageSelected(arg0);
        }
    }

    @SuppressWarnings("ObjectEquality")
    @Override
    public void setViewPager(ViewPager view) {
        if (this.mViewPager == view) {
            return;
        }
        if (this.mViewPager != null) {
            this.mViewPager.setOnPageChangeListener(null);
        }
        PagerAdapter adapter = view.getAdapter();
        if (adapter == null) {
            throw new IllegalStateException("ViewPager does not have adapter instance.");
        }
        this.mViewPager = view;
        view.setOnPageChangeListener(this);
        notifyDataSetChanged();
    }

    @Override
    public void notifyDataSetChanged() {
        this.mIconsLayout.removeAllViews();
        IconPagerAdapter iconAdapter = IconPagerAdapter.class.cast(this.mViewPager.getAdapter());
        int count = iconAdapter.getCount();
        for (int i = 0; i < count; i++) {
            IconView view = new IconView(getContext(), null, R.attr.vpiIconPageIndicatorStyle);
            view.setIndex(i);
            view.setImageResource(iconAdapter.getIconResId(i));
            view.setOnClickListener(this.mIconClickListener);
            this.mIconsLayout.addView(view);
        }
        if (this.mSelectedIndex > count) {
            this.mSelectedIndex = count - 1;
        }
        setCurrentItem(this.mSelectedIndex);
        requestLayout();
    }

    @Override
    public void setViewPager(ViewPager view, int initialPosition) {
        setViewPager(view);
        setCurrentItem(initialPosition);
    }

    @Override
    public void setCurrentItem(int item) {
        if (this.mViewPager == null) {
            throw new IllegalStateException("ViewPager has not been bound.");
        }
        this.mSelectedIndex = item;
        this.mViewPager.setCurrentItem(item);

        int tabCount = this.mIconsLayout.getChildCount();
        for (int i = 0; i < tabCount; i++) {
            View child = this.mIconsLayout.getChildAt(i);
            boolean isSelected = (i == item);
            child.setSelected(isSelected);
            if (isSelected) {
                animateToIcon(item);
            }
        }
    }

    @Override
    public void setOnPageChangeListener(OnPageChangeListener listener) {
        this.mListener = listener;
    }

    public void setIconReselectedListener(OnIconReselectedListener listener) {
        this.iconReselectedListener = listener;
    }

    /**
     * Interface for a callback when the selected tab has been reselected.
     */
    public interface OnIconReselectedListener {
        /**
         * Callback when the selected tab has been reselected.
         *
         * @param position Position of the current center item.
         */
        void onIconReselected(int position);
    }

    private static class IconView extends ImageView {
        private int index;

        public IconView(Context context) {
            super(context);
        }

        public IconView(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public IconView(Context context, AttributeSet attrs, int defStyle) {
            super(context, attrs, defStyle);
        }

        private int getIndex() {
            return this.index;
        }

        private void setIndex(int index) {
            this.index = index;
        }
    }
}
