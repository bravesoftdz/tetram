/*
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
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;
import android.support.v4.view.MotionEventCompat;
import android.support.v4.view.ViewConfigurationCompat;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

import org.jetbrains.annotations.NotNull;

/**
 * Draws a line for each page. The current page line is colored differently
 * than the unselected page lines.
 */
@SuppressWarnings("UnusedDeclaration")
public class UnderlinePageIndicator extends View implements PageIndicator {
    private static final int INVALID_POINTER = -1;
    private static final int FADE_FRAME_MS = 30;
    private final Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final Runnable mFadeRunnable = new Runnable() {
        @Override
        public void run() {
            if (!UnderlinePageIndicator.this.mFades) return;

            final int alpha = Math.max(UnderlinePageIndicator.this.mPaint.getAlpha() - UnderlinePageIndicator.this.mFadeBy, 0);
            UnderlinePageIndicator.this.mPaint.setAlpha(alpha);
            invalidate();
            if (alpha > 0) {
                postDelayed(this, FADE_FRAME_MS);
            }
        }
    };
    private boolean mFades;
    private int mFadeDelay;
    private int mFadeLength;
    private int mFadeBy;
    private ViewPager mViewPager;
    private ViewPager.OnPageChangeListener mListener;
    private int mScrollState;
    private int mCurrentPage;
    private float mPositionOffset;
    private int mTouchSlop;
    private float mLastMotionX = -1;
    private int mActivePointerId = INVALID_POINTER;
    private boolean mIsDragging;

    public UnderlinePageIndicator(Context context) {
        this(context, null);
    }

    public UnderlinePageIndicator(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.vpiUnderlinePageIndicatorStyle);
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public UnderlinePageIndicator(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        if (isInEditMode()) return;

        final Resources res = getResources();

        //Load defaults from resources
        final boolean defaultFades = res.getBoolean(R.bool.default_underline_indicator_fades);
        final int defaultFadeDelay = res.getInteger(R.integer.default_underline_indicator_fade_delay);
        final int defaultFadeLength = res.getInteger(R.integer.default_underline_indicator_fade_length);
        final int defaultSelectedColor = res.getColor(R.color.default_underline_indicator_selected_color);

        //Retrieve styles attributes
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.UnderlinePageIndicator, defStyle, 0);

        setFades(a.getBoolean(R.styleable.UnderlinePageIndicator_fades, defaultFades));
        setSelectedColor(a.getColor(R.styleable.UnderlinePageIndicator_selectedColor, defaultSelectedColor));
        setFadeDelay(a.getInteger(R.styleable.UnderlinePageIndicator_fadeDelay, defaultFadeDelay));
        setFadeLength(a.getInteger(R.styleable.UnderlinePageIndicator_fadeLength, defaultFadeLength));

        Drawable background = a.getDrawable(R.styleable.UnderlinePageIndicator_android_background);
        if (background != null) {
            setBackground(background);
        }

        a.recycle();

        final ViewConfiguration configuration = ViewConfiguration.get(context);
        this.mTouchSlop = ViewConfigurationCompat.getScaledPagingTouchSlop(configuration);
    }

    public boolean isFades() {
        return this.mFades;
    }

    public void setFades(boolean fades) {
        if (fades != this.mFades) {
            this.mFades = fades;
            if (fades) {
                post(this.mFadeRunnable);
            } else {
                removeCallbacks(this.mFadeRunnable);
                this.mPaint.setAlpha(0xFF);
                invalidate();
            }
        }
    }

    public int getFadeDelay() {
        return this.mFadeDelay;
    }

    public void setFadeDelay(int fadeDelay) {
        this.mFadeDelay = fadeDelay;
    }

    public int getFadeLength() {
        return this.mFadeLength;
    }

    public void setFadeLength(int fadeLength) {
        this.mFadeLength = fadeLength;
        this.mFadeBy = 0xFF / (this.mFadeLength / FADE_FRAME_MS);
    }

    public int getSelectedColor() {
        return this.mPaint.getColor();
    }

    public void setSelectedColor(int selectedColor) {
        this.mPaint.setColor(selectedColor);
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (this.mViewPager == null) {
            return;
        }
        final int count = this.mViewPager.getAdapter().getCount();
        if (count == 0) {
            return;
        }

        if (this.mCurrentPage >= count) {
            setCurrentItem(count - 1);
            return;
        }

        final int paddingLeft = getPaddingLeft();
        final float pageWidth = (getWidth() - paddingLeft - getPaddingRight()) / (1f * count);
        final float left = paddingLeft + (pageWidth * (this.mCurrentPage + this.mPositionOffset));
        final float right = left + pageWidth;
        final float top = getPaddingTop();
        final float bottom = getHeight() - getPaddingBottom();
        canvas.drawRect(left, top, right, bottom, this.mPaint);
    }

    @Override
    public boolean onTouchEvent(@NotNull MotionEvent event) {
        if (super.onTouchEvent(event)) {
            return true;
        }
        if ((this.mViewPager == null) || (this.mViewPager.getAdapter().getCount() == 0)) {
            return false;
        }

        final int action = event.getAction() & MotionEventCompat.ACTION_MASK;
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                this.mActivePointerId = MotionEventCompat.getPointerId(event, 0);
                this.mLastMotionX = event.getX();
                break;

            case MotionEvent.ACTION_MOVE: {
                final int activePointerIndex = MotionEventCompat.findPointerIndex(event, this.mActivePointerId);
                final float x = MotionEventCompat.getX(event, activePointerIndex);
                final float deltaX = x - this.mLastMotionX;

                if (!this.mIsDragging) {
                    if (Math.abs(deltaX) > this.mTouchSlop) {
                        this.mIsDragging = true;
                    }
                }

                if (this.mIsDragging) {
                    this.mLastMotionX = x;
                    if (this.mViewPager.isFakeDragging() || this.mViewPager.beginFakeDrag()) {
                        this.mViewPager.fakeDragBy(deltaX);
                    }
                }

                break;
            }

            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_UP:
                if (!this.mIsDragging) {
                    final int count = this.mViewPager.getAdapter().getCount();
                    final int width = getWidth();
                    final float halfWidth = width / 2f;
                    final float sixthWidth = width / 6f;

                    if ((this.mCurrentPage > 0) && (event.getX() < (halfWidth - sixthWidth))) {
                        if (action != MotionEvent.ACTION_CANCEL) {
                            this.mViewPager.setCurrentItem(this.mCurrentPage - 1);
                        }
                        return true;
                    } else if ((this.mCurrentPage < (count - 1)) && (event.getX() > (halfWidth + sixthWidth))) {
                        if (action != MotionEvent.ACTION_CANCEL) {
                            this.mViewPager.setCurrentItem(this.mCurrentPage + 1);
                        }
                        return true;
                    }
                }

                this.mIsDragging = false;
                this.mActivePointerId = INVALID_POINTER;
                if (this.mViewPager.isFakeDragging()) this.mViewPager.endFakeDrag();
                break;

            case MotionEventCompat.ACTION_POINTER_DOWN: {
                final int index = MotionEventCompat.getActionIndex(event);
                this.mLastMotionX = MotionEventCompat.getX(event, index);
                this.mActivePointerId = MotionEventCompat.getPointerId(event, index);
                break;
            }

            case MotionEventCompat.ACTION_POINTER_UP:
                final int pointerIndex = MotionEventCompat.getActionIndex(event);
                final int pointerId = MotionEventCompat.getPointerId(event, pointerIndex);
                if (pointerId == this.mActivePointerId) {
                    final int newPointerIndex = (pointerIndex == 0) ? 1 : 0;
                    this.mActivePointerId = MotionEventCompat.getPointerId(event, newPointerIndex);
                }
                this.mLastMotionX = MotionEventCompat.getX(event, MotionEventCompat.findPointerIndex(event, this.mActivePointerId));
                break;
        }

        return true;
    }

    @SuppressWarnings("ObjectEquality")
    @Override
    public void setViewPager(ViewPager view) {
        if (this.mViewPager == view) {
            return;
        }
        if (this.mViewPager != null) {
            //Clear us from the old pager.
            this.mViewPager.setOnPageChangeListener(null);
        }
        if (view.getAdapter() == null) {
            throw new IllegalStateException("ViewPager does not have adapter instance.");
        }
        this.mViewPager = view;
        this.mViewPager.setOnPageChangeListener(this);
        invalidate();
        post(new Runnable() {
            @Override
            public void run() {
                if (UnderlinePageIndicator.this.mFades) {
                    post(UnderlinePageIndicator.this.mFadeRunnable);
                }
            }
        });
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
        this.mViewPager.setCurrentItem(item);
        this.mCurrentPage = item;
        invalidate();
    }

    @Override
    public void notifyDataSetChanged() {
        invalidate();
    }

    @Override
    public void onPageScrollStateChanged(int state) {
        this.mScrollState = state;

        if (this.mListener != null) {
            this.mListener.onPageScrollStateChanged(state);
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        this.mCurrentPage = position;
        this.mPositionOffset = positionOffset;
        if (this.mFades) {
            if (positionOffsetPixels > 0) {
                removeCallbacks(this.mFadeRunnable);
                this.mPaint.setAlpha(0xFF);
            } else if (this.mScrollState != ViewPager.SCROLL_STATE_DRAGGING) {
                postDelayed(this.mFadeRunnable, this.mFadeDelay);
            }
        }
        invalidate();

        if (this.mListener != null) {
            this.mListener.onPageScrolled(position, positionOffset, positionOffsetPixels);
        }
    }

    @Override
    public void onPageSelected(int position) {
        if (this.mScrollState == ViewPager.SCROLL_STATE_IDLE) {
            this.mCurrentPage = position;
            this.mPositionOffset = 0;
            invalidate();
            this.mFadeRunnable.run();
        }
        if (this.mListener != null) {
            this.mListener.onPageSelected(position);
        }
    }

    @Override
    public void setOnPageChangeListener(ViewPager.OnPageChangeListener listener) {
        this.mListener = listener;
    }

    @Override
    public void onRestoreInstanceState(Parcelable state) {
        SavedState savedState = (SavedState) state;
        super.onRestoreInstanceState(savedState.getSuperState());
        this.mCurrentPage = savedState.currentPage;
        requestLayout();
    }

    @Override
    public Parcelable onSaveInstanceState() {
        Parcelable superState = super.onSaveInstanceState();
        SavedState savedState = new SavedState(superState);
        savedState.currentPage = this.mCurrentPage;
        return savedState;
    }

    static class SavedState extends BaseSavedState {
        @SuppressWarnings({"UnusedDeclaration", "FieldNameHidesFieldInSuperclass"})
        public static final Creator<SavedState> CREATOR = new Creator<SavedState>() {
            @Override
            public SavedState createFromParcel(Parcel source) {
                return new SavedState(source);
            }

            @Override
            public SavedState[] newArray(int size) {
                return new SavedState[size];
            }
        };
        int currentPage;

        public SavedState(Parcelable superState) {
            super(superState);
        }

        private SavedState(Parcel in) {
            super(in);
            this.currentPage = in.readInt();
        }

        @Override
        public void writeToParcel(@NotNull Parcel dest, int flags) {
            super.writeToParcel(dest, flags);
            dest.writeInt(this.currentPage);
        }
    }
}