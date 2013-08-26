/*
 * Copyright 2013 Inmite s.r.o. (www.inmite.eu).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package eu.inmite.android.lib.dialogs;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;

/**
 * Base dialog fragment for all your dialogs, stylable and same design on Android 2.2+.
 *
 * @author David Vávra (david@inmite.eu)
 */
public abstract class BaseDialogFragment extends DialogFragment {

	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState) {
		Dialog dialog = new Dialog(getActivity(), R.style.SDL_Dialog);
		// custom dialog background
		final TypedArray a = getActivity().getTheme().obtainStyledAttributes(null, R.styleable.DialogStyle, R.attr.sdlDialogStyle, 0);
		Drawable dialogBackground = a.getDrawable(R.styleable.DialogStyle_dialogBackground);
		a.recycle();
		dialog.getWindow().setBackgroundDrawable(dialogBackground);
		return dialog;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		Builder builder = new Builder(this, getActivity(), inflater, container);
		return build(builder).create();
	}

	protected abstract Builder build(Builder initialBuilder);

	@Override
	public void onDestroyView() {
		// bug in the compatibility library
		if ((getDialog() != null) && getRetainInstance()) {
			getDialog().setDismissMessage(null);
		}
		super.onDestroyView();
	}

	/**
	 * Custom dialog builder
	 */
    @SuppressWarnings("UnusedDeclaration")
    protected static class Builder {

		private final DialogFragment mDialogFragment;
		private final Context mContext;
		private final ViewGroup mContainer;
		private final LayoutInflater mInflater;

		private CharSequence mTitle;
		private CharSequence mPositiveButtonText;
		private View.OnClickListener mPositiveButtonListener;
		private CharSequence mNegativeButtonText;
		private View.OnClickListener mNegativeButtonListener;
		private CharSequence mNeutralButtonText;
		private View.OnClickListener mNeutralButtonListener;
		private CharSequence mMessage;
		private View mView;
		private boolean mViewSpacingSpecified;
		private int mViewSpacingLeft;
		private int mViewSpacingTop;
		private int mViewSpacingRight;
		private int mViewSpacingBottom;
		private ListAdapter mListAdapter;
		private int mListCheckedItemIdx;
		private AdapterView.OnItemClickListener mOnItemClickListener;
		/**
		 * Styling: *
		 */
		private int mTitleTextColor;
		private int mTitleSeparatorColor;
		private int mMessageTextColor;
		private int mButtonTextColor;
		private int mButtonSeparatorColor;
		private int mButtonBackgroundColorNormal;
		private int mButtonBackgroundColorPressed;
		private int mButtonBackgroundColorFocused;

		public Builder(DialogFragment dialogFragment, Context context, LayoutInflater inflater, ViewGroup container) {
			this.mDialogFragment = dialogFragment;
			this.mContext = context;
			this.mContainer = container;
			this.mInflater = inflater;
		}

		public Builder setTitle(int titleId) {
			this.mTitle = this.mContext.getText(titleId);
			return this;
		}

		public Builder setTitle(CharSequence title) {
			this.mTitle = title;
			return this;
		}

		public Builder setPositiveButton(int textId, final View.OnClickListener listener) {
            this.mPositiveButtonText = this.mContext.getText(textId);
            this.mPositiveButtonListener = listener;
			return this;
		}

		public Builder setPositiveButton(CharSequence text, final View.OnClickListener listener) {
            this.mPositiveButtonText = text;
            this.mPositiveButtonListener = listener;
			return this;
		}

		public Builder setNegativeButton(int textId, final View.OnClickListener listener) {
            this.mNegativeButtonText = this.mContext.getText(textId);
            this.mNegativeButtonListener = listener;
			return this;
		}

		public Builder setNegativeButton(CharSequence text, final View.OnClickListener listener) {
            this.mNegativeButtonText = text;
            this.mNegativeButtonListener = listener;
			return this;
		}

		public Builder setNeutralButton(int textId, final View.OnClickListener listener) {
            this.mNeutralButtonText = this.mContext.getText(textId);
            this.mNeutralButtonListener = listener;
			return this;
		}

		public Builder setNeutralButton(CharSequence text, final View.OnClickListener listener) {
            this.mNeutralButtonText = text;
            this.mNeutralButtonListener = listener;
			return this;
		}

		public Builder setMessage(int messageId) {
            this.mMessage = this.mContext.getText(messageId);
			return this;
		}

		public Builder setMessage(CharSequence message) {
            this.mMessage = message;
			return this;
		}

		/**
		 * Set list
		 *
		 * @param listAdapter
		 * @param checkedItemIdx Item check by default, -1 if no item should be checked
		 * @param listener
		 * @return
		 */
		public Builder setItems(ListAdapter listAdapter, int checkedItemIdx, final AdapterView.OnItemClickListener listener) {
            this.mListAdapter = listAdapter;
            this.mOnItemClickListener = listener;
            this.mListCheckedItemIdx = checkedItemIdx;
			return this;
		}

		public Builder setView(View view) {
            this.mView = view;
            this.mViewSpacingSpecified = false;
			return this;
		}

		public Builder setView(View view, int viewSpacingLeft, int viewSpacingTop,
		                       int viewSpacingRight, int viewSpacingBottom) {
            this.mView = view;
            this.mViewSpacingSpecified = true;
            this.mViewSpacingLeft = viewSpacingLeft;
            this.mViewSpacingTop = viewSpacingTop;
            this.mViewSpacingRight = viewSpacingRight;
            this.mViewSpacingBottom = viewSpacingBottom;
			return this;
		}

		public View create() {
			final Resources res = this.mContext.getResources();
			final int defaultTitleTextColor = res.getColor(R.color.sdl_title_text_dark);
			final int defaultTitleSeparatorColor = res.getColor(R.color.sdl_title_separator_dark);
			final int defaultMessageTextColor = res.getColor(R.color.sdl_message_text_dark);
			final int defaultButtonTextColor = res.getColor(R.color.sdl_button_text_dark);
			final int defaultButtonSeparatorColor = res.getColor(R.color.sdl_button_separator_dark);
			final int defaultButtonBackgroundColorNormal = res.getColor(R.color.sdl_button_normal_dark);
			final int defaultButtonBackgroundColorPressed = res.getColor(R.color.sdl_button_pressed_dark);
			final int defaultButtonBackgroundColorFocused = res.getColor(R.color.sdl_button_focused_dark);

			final TypedArray a = this.mContext.getTheme().obtainStyledAttributes(null, R.styleable.DialogStyle, R.attr.sdlDialogStyle, 0);
            this.mTitleTextColor = a.getColor(R.styleable.DialogStyle_titleTextColor, defaultTitleTextColor);
            this.mTitleSeparatorColor = a.getColor(R.styleable.DialogStyle_titleSeparatorColor, defaultTitleSeparatorColor);
            this.mMessageTextColor = a.getColor(R.styleable.DialogStyle_messageTextColor, defaultMessageTextColor);
            this.mButtonTextColor = a.getColor(R.styleable.DialogStyle_buttonTextColor, defaultButtonTextColor);
            this.mButtonSeparatorColor = a.getColor(R.styleable.DialogStyle_buttonSeparatorColor, defaultButtonSeparatorColor);
            this.mButtonBackgroundColorNormal = a.getColor(R.styleable.DialogStyle_buttonBackgroundColorNormal, defaultButtonBackgroundColorNormal);
            this.mButtonBackgroundColorPressed = a.getColor(R.styleable.DialogStyle_buttonBackgroundColorPressed, defaultButtonBackgroundColorPressed);
            this.mButtonBackgroundColorFocused = a.getColor(R.styleable.DialogStyle_buttonBackgroundColorFocused, defaultButtonBackgroundColorFocused);
			a.recycle();

			View v = getDialogLayoutAndInitTitle();

			LinearLayout content = (LinearLayout) v.findViewById(R.id.sdl__content);

			if (this.mMessage != null) {
				View viewMessage = this.mInflater.inflate(R.layout.dialog_part_message, content, false);
				TextView tvMessage = (TextView) viewMessage.findViewById(R.id.sdl__message);
				tvMessage.setText(this.mMessage);
				tvMessage.setTextColor(this.mMessageTextColor);
				content.addView(viewMessage);
			}

			if (this.mView != null) {
				FrameLayout customPanel = (FrameLayout) this.mInflater.inflate(R.layout.dialog_part_custom, content, false);
				FrameLayout custom = (FrameLayout) customPanel.findViewById(R.id.sdl__custom);
				custom.addView(this.mView, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
				if (this.mViewSpacingSpecified) {
					custom.setPadding(this.mViewSpacingLeft, this.mViewSpacingTop, this.mViewSpacingRight, this.mViewSpacingBottom);
				}
				content.addView(customPanel);
			}

			if (this.mListAdapter != null) {
				ListView list = (ListView) this.mInflater.inflate(R.layout.dialog_part_list, content, false);
				list.setAdapter(this.mListAdapter);
				list.setOnItemClickListener(this.mOnItemClickListener);
				if (this.mListCheckedItemIdx != -1) {
					list.setSelection(this.mListCheckedItemIdx);
				}
				content.addView(list);
			}

			addButtons(content);

			return v;
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private View getDialogLayoutAndInitTitle() {
			View v = this.mInflater.inflate(R.layout.dialog_part_title, this.mContainer, false);
			TextView tvTitle = (TextView) v.findViewById(R.id.sdl__title);
			View viewTitleDivider = v.findViewById(R.id.sdl__titleDivider);
			if (this.mTitle != null) {
				tvTitle.setText(this.mTitle);
				tvTitle.setTextColor(this.mTitleTextColor);
				viewTitleDivider.setBackground(new ColorDrawable(this.mTitleSeparatorColor));
			} else {
				tvTitle.setVisibility(View.GONE);
				viewTitleDivider.setVisibility(View.GONE);
			}
			return v;
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private void addButtons(LinearLayout llListDialog) {
			if ((this.mNegativeButtonText != null) || (this.mNeutralButtonText != null) || (this.mPositiveButtonText != null)) {
				View viewButtonPanel = this.mInflater.inflate(R.layout.dialog_part_button_panel, llListDialog, false);
				LinearLayout llButtonPanel = (LinearLayout) viewButtonPanel.findViewById(R.id.dialog_button_panel);
				viewButtonPanel.findViewById(R.id.dialog_horizontal_separator).setBackground(new ColorDrawable(this.mButtonSeparatorColor));

				boolean addDivider = false;

				if (Build.VERSION.SDK_INT < Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
					addDivider = addPositiveButton(llButtonPanel, addDivider);
				} else {
					addDivider = addNegativeButton(llButtonPanel, addDivider);
				}
				addDivider = addNeutralButton(llButtonPanel, addDivider);

				if (Build.VERSION.SDK_INT < Build.VERSION_CODES.ICE_CREAM_SANDWICH) {
					addNegativeButton(llButtonPanel, addDivider);
				} else {
					addPositiveButton(llButtonPanel, addDivider);
				}

				llListDialog.addView(viewButtonPanel);
			}
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private boolean addNegativeButton(ViewGroup parent, boolean addDivider) {
			if (this.mNegativeButtonText != null) {
				if (addDivider) {
					addDivider(parent);
				}
				Button btn = (Button) this.mInflater.inflate(R.layout.dialog_part_button, parent, false);
				btn.setText(this.mNegativeButtonText);
				btn.setTextColor(this.mButtonTextColor);
				btn.setBackground(getButtonBackground());
				btn.setOnClickListener(this.mNegativeButtonListener);
				parent.addView(btn);
				return true;
			}
			return addDivider;
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private boolean addPositiveButton(ViewGroup parent, boolean addDivider) {
			if (this.mPositiveButtonText != null) {
				if (addDivider) {
					addDivider(parent);
				}
				Button btn = (Button) this.mInflater.inflate(R.layout.dialog_part_button, parent, false);
				btn.setText(this.mPositiveButtonText);
				btn.setTextColor(this.mButtonTextColor);
				btn.setBackground(getButtonBackground());
				btn.setOnClickListener(this.mPositiveButtonListener);
				parent.addView(btn);
				return true;
			}
			return addDivider;
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private boolean addNeutralButton(ViewGroup parent, boolean addDivider) {
			if (this.mNeutralButtonText != null) {
				if (addDivider) {
					addDivider(parent);
				}
				Button btn = (Button) this.mInflater.inflate(R.layout.dialog_part_button, parent, false);
				btn.setText(this.mNeutralButtonText);
				btn.setTextColor(this.mButtonTextColor);
				btn.setBackground(getButtonBackground());
				btn.setOnClickListener(this.mNeutralButtonListener);
				parent.addView(btn);
				return true;
			}
			return addDivider;
		}

		@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        private void addDivider(ViewGroup parent) {
			View view = this.mInflater.inflate(R.layout.dialog_part_button_separator, parent, false);
			view.findViewById(R.id.dialog_button_separator).setBackground(new ColorDrawable(this.mButtonSeparatorColor));
			parent.addView(view);
		}

		private StateListDrawable getButtonBackground() {
			int[] pressedState = {android.R.attr.state_pressed};
			int[] focusedState = {android.R.attr.state_focused};
			int[] defaultState = {android.R.attr.state_enabled};
			ColorDrawable colorDefault = new ColorDrawable(this.mButtonBackgroundColorNormal);
			ColorDrawable colorPressed = new ColorDrawable(this.mButtonBackgroundColorPressed);
			ColorDrawable colorFocused = new ColorDrawable(this.mButtonBackgroundColorFocused);
			StateListDrawable background = new StateListDrawable();
			background.addState(pressedState, colorPressed);
			background.addState(focusedState, colorFocused);
			background.addState(defaultState, colorDefault);
			return background;
		}
	}
}
