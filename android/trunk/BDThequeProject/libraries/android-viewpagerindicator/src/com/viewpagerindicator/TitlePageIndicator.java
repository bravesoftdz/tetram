/*
 * Copyright (C) 2011 Jake Wharton
 * Copyright (C) 2011 Patrik Akerfeldt
 * Copyright (C) 2011 Francisco Figueiredo Jr.
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

import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
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
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;

/**
 * A TitlePageIndicator is a PageIndicator which displays the title of left view
 * (if exist), the title of the current select view (centered) and the title of
 * the right view (if exist). When the user scrolls the ViewPager then titles are
 * also scrolled.
 */
@SuppressWarnings("UnusedDeclaration")
public class TitlePageIndicator extends View implements PageIndicator {
    /**
     * Percentage indicating what percentage of the screen width away from
     * center should the underline be fully faded. A value of 0.25 means that
     * halfway between the center of the screen and an edge.
     */
    private static final float SELECTION_FADE_PERCENTAGE = 0.25f;
    /**
     * Percentage indicating what percentage of the screen width away from
     * center should the selected text bold turn off. A value of 0.05 means
     * that 10% between the center and an edge.
     */
    private static final float BOLD_FADE_PERCENTAGE = 0.05f;
    /**
     * Title text used when no title is provided by the adapter.
     */
    private static final String EMPTY_TITLE = "";
    private static final int INVALID_POINTER = -1;
    private final Paint mPaintText = new Paint();
    private final Rect mBounds = new Rect();
    private final Paint mPaintFooterLine = new Paint();
    private final Paint mPaintFooterIndicator = new Paint();
    private ViewPager mViewPager;
    private ViewPager.OnPageChangeListener mListener;
    private int mCurrentPage = -1;
    private float mPageOffset;
    private int mScrollState;
    private boolean mBoldText;
    private int mColorText;
    private int mColorSelected;
    private Path mPath = new Path();
    private IndicatorStyle mFooterIndicatorStyle;
    private LinePosition mLinePosition;
    private float mFooterIndicatorHeight;
    private float mFooterIndicatorUnderlinePadding;
    private float mFooterPadding;
    private float mTitlePadding;
    private float mTopPadding;
    /**
     * Left and right side padding for not active view titles.
     */
    private float mClipPadding;
    private float mFooterLineHeight;
    private int mTouchSlop;
    private float mLastMotionX = -1;
    private int mActivePointerId = INVALID_POINTER;
    private boolean mIsDragging;
    private OnCenterItemClickListener mCenterItemClickListener;

    public TitlePageIndicator(Context context) {
        this(context, null);
    }

    public TitlePageIndicator(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.vpiTitlePageIndicatorStyle);
    }

    @SuppressWarnings("SuspiciousNameCombination")
    public TitlePageIndicator(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        if (isInEditMode()) return;

        //Load defaults from resources
        final Resources res = getResources();
        final int defaultFooterColor = res.getColor(R.color.default_title_indicator_footer_color);
        final float defaultFooterLineHeight = res.getDimension(R.dimen.default_title_indicator_footer_line_height);
        final int defaultFooterIndicatorStyle = res.getInteger(R.integer.default_title_indicator_footer_indicator_style);
        final float defaultFooterIndicatorHeight = res.getDimension(R.dimen.default_title_indicator_footer_indicator_height);
        final float defaultFooterIndicatorUnderlinePadding = res.getDimension(R.dimen.default_title_indicator_footer_indicator_underline_padding);
        final float defaultFooterPadding = res.getDimension(R.dimen.default_title_indicator_footer_padding);
        final int defaultLinePosition = res.getInteger(R.integer.default_title_indicator_line_position);
        final int defaultSelectedColor = res.getColor(R.color.default_title_indicator_selected_color);
        final boolean defaultSelectedBold = res.getBoolean(R.bool.default_title_indicator_selected_bold);
        final int defaultTextColor = res.getColor(R.color.default_title_indicator_text_color);
        final float defaultTextSize = res.getDimension(R.dimen.default_title_indicator_text_size);
        final float defaultTitlePadding = res.getDimension(R.dimen.default_title_indicator_title_padding);
        final float defaultClipPadding = res.getDimension(R.dimen.default_title_indicator_clip_padding);
        final float defaultTopPadding = res.getDimension(R.dimen.default_title_indicator_top_padding);

        //Retrieve styles attributes
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.TitlePageIndicator, defStyle, 0);

        //Retrieve the colors to be used for this view and apply them.
        this.mFooterLineHeight = a.getDimension(R.styleable.TitlePageIndicator_footerLineHeight, defaultFooterLineHeight);
        this.mFooterIndicatorStyle = IndicatorStyle.fromValue(a.getInteger(R.styleable.TitlePageIndicator_footerIndicatorStyle, defaultFooterIndicatorStyle));
        this.mFooterIndicatorHeight = a.getDimension(R.styleable.TitlePageIndicator_footerIndicatorHeight, defaultFooterIndicatorHeight);
        this.mFooterIndicatorUnderlinePadding = a.getDimension(R.styleable.TitlePageIndicator_footerIndicatorUnderlinePadding, defaultFooterIndicatorUnderlinePadding);
        this.mFooterPadding = a.getDimension(R.styleable.TitlePageIndicator_footerPadding, defaultFooterPadding);
        this.mLinePosition = LinePosition.fromValue(a.getInteger(R.styleable.TitlePageIndicator_linePosition, defaultLinePosition));
        this.mTopPadding = a.getDimension(R.styleable.TitlePageIndicator_topPadding, defaultTopPadding);
        this.mTitlePadding = a.getDimension(R.styleable.TitlePageIndicator_titlePadding, defaultTitlePadding);
        this.mClipPadding = a.getDimension(R.styleable.TitlePageIndicator_clipPadding, defaultClipPadding);
        this.mColorSelected = a.getColor(R.styleable.TitlePageIndicator_selectedColor, defaultSelectedColor);
        this.mColorText = a.getColor(R.styleable.TitlePageIndicator_android_textColor, defaultTextColor);
        this.mBoldText = a.getBoolean(R.styleable.TitlePageIndicator_selectedBold, defaultSelectedBold);

        final float textSize = a.getDimension(R.styleable.TitlePageIndicator_android_textSize, defaultTextSize);
        final int footerColor = a.getColor(R.styleable.TitlePageIndicator_footerColor, defaultFooterColor);
        this.mPaintText.setTextSize(textSize);
        this.mPaintText.setAntiAlias(true);
        this.mPaintFooterLine.setStyle(Paint.Style.FILL_AND_STROKE);
        this.mPaintFooterLine.setStrokeWidth(this.mFooterLineHeight);
        this.mPaintFooterLine.setColor(footerColor);
        this.mPaintFooterIndicator.setStyle(Paint.Style.FILL_AND_STROKE);
        this.mPaintFooterIndicator.setColor(footerColor);

        Drawable background = a.getDrawable(R.styleable.TitlePageIndicator_android_background);
        if (background != null) {
            setBackground(background);
        }

        a.recycle();

        final ViewConfiguration configuration = ViewConfiguration.get(context);
        this.mTouchSlop = ViewConfigurationCompat.getScaledPagingTouchSlop(configuration);
    }

    public int getFooterColor() {
        return this.mPaintFooterLine.getColor();
    }

    public void setFooterColor(int footerColor) {
        this.mPaintFooterLine.setColor(footerColor);
        this.mPaintFooterIndicator.setColor(footerColor);
        invalidate();
    }

    public float getFooterLineHeight() {
        return this.mFooterLineHeight;
    }

    @SuppressWarnings("SuspiciousNameCombination")
    public void setFooterLineHeight(float footerLineHeight) {
        this.mFooterLineHeight = footerLineHeight;
        this.mPaintFooterLine.setStrokeWidth(this.mFooterLineHeight);
        invalidate();
    }

    public float getFooterIndicatorHeight() {
        return this.mFooterIndicatorHeight;
    }

    public void setFooterIndicatorHeight(float footerTriangleHeight) {
        this.mFooterIndicatorHeight = footerTriangleHeight;
        invalidate();
    }

    public float getFooterIndicatorPadding() {
        return this.mFooterPadding;
    }

    @SuppressWarnings("MethodParameterNamingConvention")
    public void setFooterIndicatorPadding(float footerIndicatorPadding) {
        this.mFooterPadding = footerIndicatorPadding;
        invalidate();
    }

    public IndicatorStyle getFooterIndicatorStyle() {
        return this.mFooterIndicatorStyle;
    }

    public void setFooterIndicatorStyle(IndicatorStyle indicatorStyle) {
        this.mFooterIndicatorStyle = indicatorStyle;
        invalidate();
    }

    public LinePosition getLinePosition() {
        return this.mLinePosition;
    }

    public void setLinePosition(LinePosition linePosition) {
        this.mLinePosition = linePosition;
        invalidate();
    }

    public int getSelectedColor() {
        return this.mColorSelected;
    }

    public void setSelectedColor(int selectedColor) {
        this.mColorSelected = selectedColor;
        invalidate();
    }

    public boolean isSelectedBold() {
        return this.mBoldText;
    }

    public void setSelectedBold(boolean selectedBold) {
        this.mBoldText = selectedBold;
        invalidate();
    }

    public int getTextColor() {
        return this.mColorText;
    }

    public void setTextColor(int textColor) {
        this.mPaintText.setColor(textColor);
        this.mColorText = textColor;
        invalidate();
    }

    public float getTextSize() {
        return this.mPaintText.getTextSize();
    }

    public void setTextSize(float textSize) {
        this.mPaintText.setTextSize(textSize);
        invalidate();
    }

    public float getTitlePadding() {
        return this.mTitlePadding;
    }

    public void setTitlePadding(float titlePadding) {
        this.mTitlePadding = titlePadding;
        invalidate();
    }

    public float getTopPadding() {
        return this.mTopPadding;
    }

    public void setTopPadding(float topPadding) {
        this.mTopPadding = topPadding;
        invalidate();
    }

    public float getClipPadding() {
        return this.mClipPadding;
    }

    public void setClipPadding(float clipPadding) {
        this.mClipPadding = clipPadding;
        invalidate();
    }

    public Typeface getTypeface() {
        return this.mPaintText.getTypeface();
    }

    public void setTypeface(Typeface typeface) {
        this.mPaintText.setTypeface(typeface);
        invalidate();
    }

    /*
     * (non-Javadoc)
     *
     * @see android.view.View#onDraw(android.graphics.Canvas)
     */
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

        // mCurrentPage is -1 on first start and after orientation changed. If so, retrieve the correct index from viewpager.
        if ((this.mCurrentPage == -1) && (this.mViewPager != null)) {
            this.mCurrentPage = this.mViewPager.getCurrentItem();
        }

        //Calculate views bounds
        ArrayList<Rect> bounds = calculateAllBounds(this.mPaintText);
        final int boundsSize = bounds.size();

        //Make sure we're on a page that still exists
        if (this.mCurrentPage >= boundsSize) {
            setCurrentItem(boundsSize - 1);
            return;
        }

        final int countMinusOne = count - 1;
        final float halfWidth = getWidth() / 2f;
        final int left = getLeft();
        final float leftClip = left + this.mClipPadding;
        final int width = getWidth();
        int height = getHeight();
        final int right = left + width;
        final float rightClip = right - this.mClipPadding;

        int page = this.mCurrentPage;
        float offsetPercent;
        if (this.mPageOffset <= 0.5) {
            offsetPercent = this.mPageOffset;
        } else {
            page += 1;
            offsetPercent = 1 - this.mPageOffset;
        }
        final boolean currentSelected = (offsetPercent <= SELECTION_FADE_PERCENTAGE);
        final boolean currentBold = (offsetPercent <= BOLD_FADE_PERCENTAGE);
        final float selectedPercent = (SELECTION_FADE_PERCENTAGE - offsetPercent) / SELECTION_FADE_PERCENTAGE;

        //Verify if the current view must be clipped to the screen
        Rect curPageBound = bounds.get(this.mCurrentPage);
        float curPageWidth = curPageBound.right - curPageBound.left;
        if (curPageBound.left < leftClip) {
            //Try to clip to the screen (left side)
            clipViewOnTheLeft(curPageBound, curPageWidth, left);
        }
        if (curPageBound.right > rightClip) {
            //Try to clip to the screen (right side)
            clipViewOnTheRight(curPageBound, curPageWidth, right);
        }

        //Left views starting from the current position
        if (this.mCurrentPage > 0) {
            for (int i = this.mCurrentPage - 1; i >= 0; i--) {
                Rect bound = bounds.get(i);
                //Is left side is outside the screen
                if (bound.left < leftClip) {
                    int w = bound.right - bound.left;
                    //Try to clip to the screen (left side)
                    clipViewOnTheLeft(bound, w, left);
                    //Except if there's an intersection with the right view
                    Rect rightBound = bounds.get(i + 1);
                    //Intersection
                    if ((bound.right + this.mTitlePadding) > rightBound.left) {
                        bound.left = (int) (rightBound.left - w - this.mTitlePadding);
                        bound.right = bound.left + w;
                    }
                }
            }
        }
        //Right views starting from the current position
        if (this.mCurrentPage < countMinusOne) {
            for (int i = this.mCurrentPage + 1; i < count; i++) {
                Rect bound = bounds.get(i);
                //If right side is outside the screen
                if (bound.right > rightClip) {
                    int w = bound.right - bound.left;
                    //Try to clip to the screen (right side)
                    clipViewOnTheRight(bound, w, right);
                    //Except if there's an intersection with the left view
                    Rect leftBound = bounds.get(i - 1);
                    //Intersection
                    if ((bound.left - this.mTitlePadding) < leftBound.right) {
                        bound.left = (int) (leftBound.right + this.mTitlePadding);
                        bound.right = bound.left + w;
                    }
                }
            }
        }

        //Now draw views
        int colorTextAlpha = this.mColorText >>> 24;
        for (int i = 0; i < count; i++) {
            //Get the title
            Rect bound = bounds.get(i);
            //Only if one side is visible
            if (((bound.left > left) && (bound.left < right)) || ((bound.right > left) && (bound.right < right))) {
                final boolean currentPage = (i == page);
                final CharSequence pageTitle = getTitle(i);

                //Only set bold if we are within bounds
                this.mPaintText.setFakeBoldText(currentPage && currentBold && this.mBoldText);

                //Draw text as unselected
                this.mPaintText.setColor(this.mColorText);
                if (currentPage && currentSelected) {
                    //Fade out/in unselected text as the selected text fades in/out
                    this.mPaintText.setAlpha(colorTextAlpha - (int) (colorTextAlpha * selectedPercent));
                }

                //Except if there's an intersection with the right view
                if (i < (boundsSize - 1)) {
                    Rect rightBound = bounds.get(i + 1);
                    //Intersection
                    if ((bound.right + this.mTitlePadding) > rightBound.left) {
                        int w = bound.right - bound.left;
                        bound.left = (int) (rightBound.left - w - this.mTitlePadding);
                        bound.right = bound.left + w;
                    }
                }
                canvas.drawText(pageTitle, 0, pageTitle.length(), bound.left, bound.bottom + this.mTopPadding, this.mPaintText);

                //If we are within the selected bounds draw the selected text
                if (currentPage && currentSelected) {
                    this.mPaintText.setColor(this.mColorSelected);
                    this.mPaintText.setAlpha((int) ((this.mColorSelected >>> 24) * selectedPercent));
                    canvas.drawText(pageTitle, 0, pageTitle.length(), bound.left, bound.bottom + this.mTopPadding, this.mPaintText);
                }
            }
        }

        //If we want the line on the top change height to zero and invert the line height to trick the drawing code
        float footerLineHeight = this.mFooterLineHeight;
        float footerIndicatorLineHeight = this.mFooterIndicatorHeight;
        if (this.mLinePosition == LinePosition.Top) {
            height = 0;
            footerLineHeight = -footerLineHeight;
            footerIndicatorLineHeight = -footerIndicatorLineHeight;
        }

        //Draw the footer line
        this.mPath.reset();
        this.mPath.moveTo(0, height - (footerLineHeight / 2f));
        this.mPath.lineTo(width, height - (footerLineHeight / 2f));
        this.mPath.close();
        canvas.drawPath(this.mPath, this.mPaintFooterLine);

        float heightMinusLine = height - footerLineHeight;
        switch (this.mFooterIndicatorStyle) {
            case Triangle:
                this.mPath.reset();
                this.mPath.moveTo(halfWidth, heightMinusLine - footerIndicatorLineHeight);
                this.mPath.lineTo(halfWidth + footerIndicatorLineHeight, heightMinusLine);
                this.mPath.lineTo(halfWidth - footerIndicatorLineHeight, heightMinusLine);
                this.mPath.close();
                canvas.drawPath(this.mPath, this.mPaintFooterIndicator);
                break;

            case Underline:
                if (!currentSelected || (page >= boundsSize)) {
                    break;
                }

                Rect underlineBounds = bounds.get(page);
                final float rightPlusPadding = underlineBounds.right + this.mFooterIndicatorUnderlinePadding;
                final float leftMinusPadding = underlineBounds.left - this.mFooterIndicatorUnderlinePadding;
                final float heightMinusLineMinusIndicator = heightMinusLine - footerIndicatorLineHeight;

                this.mPath.reset();
                this.mPath.moveTo(leftMinusPadding, heightMinusLine);
                this.mPath.lineTo(rightPlusPadding, heightMinusLine);
                this.mPath.lineTo(rightPlusPadding, heightMinusLineMinusIndicator);
                this.mPath.lineTo(leftMinusPadding, heightMinusLineMinusIndicator);
                this.mPath.close();

                this.mPaintFooterIndicator.setAlpha((int) (0xFF * selectedPercent));
                canvas.drawPath(this.mPath, this.mPaintFooterIndicator);
                this.mPaintFooterIndicator.setAlpha(0xFF);
                break;
        }
    }

    @Override
    public boolean onTouchEvent(@NotNull android.view.MotionEvent event) {
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
                    final float leftThird = halfWidth - sixthWidth;
                    final float rightThird = halfWidth + sixthWidth;
                    final float eventX = event.getX();

                    if (eventX < leftThird) {
                        if (this.mCurrentPage > 0) {
                            if (action != MotionEvent.ACTION_CANCEL) {
                                this.mViewPager.setCurrentItem(this.mCurrentPage - 1);
                            }
                            return true;
                        }
                    } else if (eventX > rightThird) {
                        if (this.mCurrentPage < (count - 1)) {
                            if (action != MotionEvent.ACTION_CANCEL) {
                                this.mViewPager.setCurrentItem(this.mCurrentPage + 1);
                            }
                            return true;
                        }
                    } else {
                        //Middle third
                        if ((this.mCenterItemClickListener != null) && (action != MotionEvent.ACTION_CANCEL)) {
                            this.mCenterItemClickListener.onCenterItemClick(this.mCurrentPage);
                        }
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

    /**
     * Set bounds for the right textView including clip padding.
     *
     * @param curViewBound current bounds.
     * @param curViewWidth width of the view.
     */
    private void clipViewOnTheRight(Rect curViewBound, float curViewWidth, int right) {
        curViewBound.right = (int) (right - this.mClipPadding);
        curViewBound.left = (int) (curViewBound.right - curViewWidth);
    }

    /**
     * Set bounds for the left textView including clip padding.
     *
     * @param curViewBound current bounds.
     * @param curViewWidth width of the view.
     */
    private void clipViewOnTheLeft(Rect curViewBound, float curViewWidth, int left) {
        curViewBound.left = (int) (left + this.mClipPadding);
        curViewBound.right = (int) (this.mClipPadding + curViewWidth);
    }

    /**
     * Calculate views bounds and scroll them according to the current index
     *
     * @param paint
     * @return
     */
    private ArrayList<Rect> calculateAllBounds(Paint paint) {
        ArrayList<Rect> list = new ArrayList<Rect>();
        //For each views (If no values then add a fake one)
        final int count = this.mViewPager.getAdapter().getCount();
        final int width = getWidth();
        final int halfWidth = width / 2;
        for (int i = 0; i < count; i++) {
            Rect bounds = calcBounds(i, paint);
            int w = bounds.right - bounds.left;
            int h = bounds.bottom - bounds.top;
            bounds.left = (int) ((halfWidth - (w / 2f)) + ((i - this.mCurrentPage - this.mPageOffset) * width));
            bounds.right = bounds.left + w;
            bounds.top = 0;
            bounds.bottom = h;
            list.add(bounds);
        }

        return list;
    }

    /**
     * Calculate the bounds for a view's title
     *
     * @param index
     * @param paint
     * @return
     */
    private Rect calcBounds(int index, Paint paint) {
        //Calculate the text bounds
        Rect bounds = new Rect();
        CharSequence title = getTitle(index);
        bounds.right = (int) paint.measureText(title, 0, title.length());
        bounds.bottom = (int) (paint.descent() - paint.ascent());
        return bounds;
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
        if (view.getAdapter() == null) {
            throw new IllegalStateException("ViewPager does not have adapter instance.");
        }
        this.mViewPager = view;
        this.mViewPager.setOnPageChangeListener(this);
        invalidate();
    }

    @Override
    public void setViewPager(ViewPager view, int initialPosition) {
        setViewPager(view);
        setCurrentItem(initialPosition);
    }

    @Override
    public void notifyDataSetChanged() {
        invalidate();
    }

    /**
     * Set a callback listener for the center item click.
     *
     * @param listener Callback instance.
     */
    public void setOnCenterItemClickListener(OnCenterItemClickListener listener) {
        this.mCenterItemClickListener = listener;
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
    public void onPageScrollStateChanged(int state) {
        this.mScrollState = state;

        if (this.mListener != null) {
            this.mListener.onPageScrollStateChanged(state);
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        this.mCurrentPage = position;
        this.mPageOffset = positionOffset;
        invalidate();

        if (this.mListener != null) {
            this.mListener.onPageScrolled(position, positionOffset, positionOffsetPixels);
        }
    }

    @Override
    public void onPageSelected(int position) {
        if (this.mScrollState == ViewPager.SCROLL_STATE_IDLE) {
            this.mCurrentPage = position;
            invalidate();
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
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        //Measure our width in whatever mode specified
        final int measuredWidth = MeasureSpec.getSize(widthMeasureSpec);

        //Determine our height
        float height;
        final int heightSpecMode = MeasureSpec.getMode(heightMeasureSpec);
        if (heightSpecMode == MeasureSpec.EXACTLY) {
            //We were told how big to be
            height = MeasureSpec.getSize(heightMeasureSpec);
        } else {
            //Calculate the text bounds
            this.mBounds.setEmpty();
            this.mBounds.bottom = (int) (this.mPaintText.descent() - this.mPaintText.ascent());
            height = this.mBounds.bottom - this.mBounds.top + this.mFooterLineHeight + this.mFooterPadding + this.mTopPadding;
            if (this.mFooterIndicatorStyle != IndicatorStyle.None) {
                height += this.mFooterIndicatorHeight;
            }
        }
        final int measuredHeight = (int) height;

        setMeasuredDimension(measuredWidth, measuredHeight);
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

    private CharSequence getTitle(int i) {
        CharSequence title = this.mViewPager.getAdapter().getPageTitle(i);
        if (title == null) {
            title = EMPTY_TITLE;
        }
        return title;
    }

    public enum IndicatorStyle {
        None(0), Triangle(1), Underline(2);
        public final int value;

        private IndicatorStyle(int value) {
            this.value = value;
        }

        @Nullable
        public static IndicatorStyle fromValue(int value) {
            for (IndicatorStyle style : IndicatorStyle.values()) {
                if (style.value == value) {
                    return style;
                }
            }
            return null;
        }
    }

    public enum LinePosition {
        Bottom(0), Top(1);
        public final int value;

        private LinePosition(int value) {
            this.value = value;
        }

        @Nullable
        public static LinePosition fromValue(int value) {
            for (LinePosition position : LinePosition.values()) {
                if (position.value == value) {
                    return position;
                }
            }
            return null;
        }
    }

    /**
     * Interface for a callback when the center item has been clicked.
     */
    public interface OnCenterItemClickListener {
        /**
         * Callback when the center item has been clicked.
         *
         * @param position Position of the current center item.
         */
        void onCenterItemClick(int position);
    }

    static class SavedState extends BaseSavedState {
        @SuppressWarnings({"UnusedDeclaration", "FieldNameHidesFieldInSuperclass"})
        public static final Parcelable.Creator<SavedState> CREATOR = new Parcelable.Creator<SavedState>() {
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
