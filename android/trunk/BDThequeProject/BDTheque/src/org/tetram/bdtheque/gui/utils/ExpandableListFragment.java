package org.tetram.bdtheque.gui.utils;

import android.app.Fragment;
import android.os.Bundle;
import android.os.Handler;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.TextView;
import org.tetram.bdtheque.R;

@SuppressWarnings("UnusedDeclaration")
public class ExpandableListFragment extends Fragment implements
        ExpandableListView.OnChildClickListener,
        ExpandableListView.OnGroupCollapseListener,
        ExpandableListView.OnGroupExpandListener {

    static final int INTERNAL_EMPTY_ID = 0x00ff0001;
    static final int INTERNAL_PROGRESS_CONTAINER_ID = 0x00ff0002;
    static final int INTERNAL_LIST_CONTAINER_ID = 0x00ff0003;

    private final Handler handler = new Handler();

    private final Runnable requestFocus = new Runnable() {
        @Override
        public void run() {
            ExpandableListFragment.this.expandableList.focusableViewAvailable(ExpandableListFragment.this.expandableList);
        }
    };

    private final AdapterView.OnItemClickListener onClickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(final AdapterView<?> parent, final View view, final int position, final long id) {
            onListItemClick((ExpandableListView) parent, view, position, id);
        }
    };

    ExpandableListAdapter listAdapter;
    ExpandableListView expandableList;
    boolean finishedStart;
    View emptyView;
    TextView emptyTextView;
    View progressContainer;
    View expandableListContainer;
    CharSequence emptyText;
    boolean expandableListShown;

    /**
     * Provide default implementation to return a simple list view.  Subclasses
     * can override to replace with their own layout.  If doing so, the
     * returned view hierarchy <em>must</em> have a ListView whose id
     * is {@link android.R.id#list android.R.id.list} and can optionally
     * have a sibling view id {@link android.R.id#empty android.R.id.empty}
     * that is to be shown when the list is empty.
     * <p/>
     * <p>If you are overriding this method with your own custom content,
     * consider including the standard layout {@link android.R.layout#list_content}
     * in your layout file, so that you continue to retain all of the standard
     * behavior of ListFragment.  In particular, this is currently the only
     * way to have the built-in indeterminant progress state be shown.
     */
    @Override
    public View onCreateView(final LayoutInflater inflater, final ViewGroup container, final Bundle savedInstanceState) {
        return inflater.inflate(R.layout.treeview, container);
    }

    /**
     * Attach to list view once the view hierarchy has been created.
     */
    @Override
    public void onViewCreated(final View view, final Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ensureList();
    }

    /**
     * Detach from list view.
     */
    @Override
    public void onDestroyView() {
        this.handler.removeCallbacks(this.requestFocus);
        this.expandableList = null;
        this.expandableListShown = false;
        this.emptyView = this.progressContainer = this.expandableListContainer = null;
        this.emptyTextView = null;
        super.onDestroyView();
    }

    /**
     * This method will be called when an item in the list is selected.
     * Subclasses should override. Subclasses can call
     * getListView().getItemAtPosition(position) if they need to access the
     * data associated with the selected item.
     *
     * @param listView The ListView where the click happened
     * @param view     The view that was clicked within the ListView
     * @param position The position of the view in the list
     * @param id       The row id of the item that was clicked
     */
    public void onListItemClick(final ExpandableListView listView, final View view, final int position, final long id) {
    }

    /**
     * Provide the cursor for the list view.
     */
    public void setListAdapter(final ExpandableListAdapter adapter) {
        final boolean hadAdapter = this.listAdapter != null;
        this.listAdapter = adapter;
        if (this.expandableList != null) {
            this.expandableList.setAdapter(adapter);
            if (!this.expandableListShown && !hadAdapter) {
                // The list was hidden, and previously didn't have an
                // adapter.  It is now time to show it.
                setListShown(true, getView().getWindowToken() != null);
            }
        }
    }

    /**
     * Set the currently selected list item to the specified
     * position with the adapter's data
     *
     * @param position the position of the item to be selected
     */
    public void setSelection(final int position) {
        ensureList();
        this.expandableList.setSelection(position);
    }

    /**
     * Get the position of the currently selected list item.
     */
    public int getSelectedItemPosition() {
        ensureList();
        return this.expandableList.getSelectedItemPosition();
    }

    /**
     * Get the cursor row ID of the currently selected list item.
     */
    public long getSelectedItemId() {
        ensureList();
        return this.expandableList.getSelectedItemId();
    }

    /**
     * Get the activity's list view widget.
     */
    public ExpandableListView getListView() {
        ensureList();
        return this.expandableList;
    }

    /**
     * The default content for a ListFragment has a TextView that can
     * be shown when the list is empty.  If you would like to have it
     * shown, call this method to supply the text it should use.
     */
    @SuppressWarnings({"UnusedDeclaration", "VariableNotUsedInsideIf"})
    public void setEmptyText(final CharSequence text) {
        ensureList();
        if (this.emptyTextView == null) {
            throw new IllegalStateException("Can't be used with a custom content view");
        }
        this.emptyTextView.setText(text);
        if (this.emptyText == null) {
            this.expandableList.setEmptyView(this.emptyTextView);
        }
        this.emptyText = text;
    }

    /**
     * Control whether the list is being displayed.  You can make it not
     * displayed if you are waiting for the initial data to show in it.  During
     * this time an indeterminant progress indicator will be shown instead.
     * <p/>
     * <p>Applications do not normally need to use this themselves.  The default
     * behavior of ListFragment is to start with the list not being shown, only
     * showing it once an adapter is given with {@link #setListAdapter(ExpandableListAdapter)}.
     * If the list at that point had not been shown, when it does get shown
     * it will be do without the user ever seeing the hidden state.
     *
     * @param shown If true, the list view is shown; if false, the progress
     *              indicator.  The initial value is true.
     */
    public void setListShown(final boolean shown) {
        setListShown(shown, true);
    }

    /**
     * Like {@link #setListShown(boolean)}, but no animation is used when
     * transitioning from the previous state.
     */
    public void setListShownNoAnimation(final boolean shown) {
        setListShown(shown, false);
    }

    /**
     * Control whether the list is being displayed.  You can make it not
     * displayed if you are waiting for the initial data to show in it.  During
     * this time an indeterminant progress indicator will be shown instead.
     *
     * @param shown   If true, the list view is shown; if false, the progress
     *                indicator.  The initial value is true.
     * @param animate If true, an animation will be used to transition to the
     *                new state.
     */
    private void setListShown(final boolean shown, final boolean animate) {
        ensureList();
        if (this.progressContainer == null) {
            throw new IllegalStateException("Can't be used with a custom content view");
        }
        if (this.expandableListShown == shown) {
            return;
        }
        this.expandableListShown = shown;
        if (shown) {
            if (animate) {
                this.progressContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_out));
                this.expandableListContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_in));
            } else {
                this.progressContainer.clearAnimation();
                this.expandableListContainer.clearAnimation();
            }
            this.progressContainer.setVisibility(View.GONE);
            this.expandableListContainer.setVisibility(View.VISIBLE);
        } else {
            if (animate) {
                this.progressContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_in));
                this.expandableListContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_out));
            } else {
                this.progressContainer.clearAnimation();
                this.expandableListContainer.clearAnimation();
            }
            this.progressContainer.setVisibility(View.VISIBLE);
            this.expandableListContainer.setVisibility(View.GONE);
        }
    }

    /**
     * Get the ListAdapter associated with this activity's ListView.
     */
    public ExpandableListAdapter getListAdapter() {
        return this.listAdapter;
    }

    private void ensureList() {
        if (this.expandableList != null) {
            return;
        }
        final View rootView = getView();
        if (rootView == null) {
            throw new IllegalStateException("Content view not yet created");
        }
        if (rootView instanceof ExpandableListView) {
            this.expandableList = (ExpandableListView) rootView;
        } else {
            this.emptyTextView = (TextView) rootView.findViewById(INTERNAL_EMPTY_ID);
            if (this.emptyTextView == null) {
                this.emptyView = rootView.findViewById(android.R.id.empty);
            } else {
                this.emptyTextView.setVisibility(View.GONE);
            }
            this.progressContainer = rootView.findViewById(INTERNAL_PROGRESS_CONTAINER_ID);
            this.expandableListContainer = rootView.findViewById(INTERNAL_LIST_CONTAINER_ID);
            final View rawExpandableListView = rootView.findViewById(android.R.id.list);
            if (!(rawExpandableListView instanceof ExpandableListView)) {
                if (rawExpandableListView == null) {
                    throw new RuntimeException(
                            "Your content must have a ListView whose id attribute is " +
                                    "'android.R.id.list'");
                }
                throw new RuntimeException(
                        "Content has view with id attribute 'android.R.id.list' "
                                + "that is not a ListView class");
            }
            this.expandableList = (ExpandableListView) rawExpandableListView;
            if (this.emptyView != null) {
                this.expandableList.setEmptyView(this.emptyView);
            } else if (this.emptyText != null) {
                this.emptyTextView.setText(this.emptyText);
                this.expandableList.setEmptyView(this.emptyTextView);
            }
        }
        this.expandableListShown = true;
        this.expandableList.setOnItemClickListener(this.onClickListener);
        if (this.listAdapter != null) {
            final ExpandableListAdapter adapter = this.listAdapter;
            this.listAdapter = null;
            setListAdapter(adapter);
        } else {
            // We are starting without an adapter, so assume we won't
            // have our data right away and start with the progress indicator.
            if (this.progressContainer != null) {
                setListShown(false, false);
            }
        }
        this.handler.post(this.requestFocus);
    }

    /**
     * Override this to populate the context menu when an item is long pressed. menuInfo
     * will contain an {@link android.widget.ExpandableListView.ExpandableListContextMenuInfo}
     * whose packedPosition is a packed position
     * that should be used with {@link ExpandableListView#getPackedPositionType(long)} and
     * the other similar methods.
     * <p/>
     * {@inheritDoc}
     */
    @Override
    public void onCreateContextMenu(final ContextMenu menu, final View v, final ContextMenu.ContextMenuInfo menuInfo) {
    }

    /**
     * Override this for receiving callbacks when a child has been clicked.
     * <p/>
     * {@inheritDoc}
     */
    @Override
    public boolean onChildClick(final ExpandableListView parent, final View v, final int groupPosition, final int childPosition, final long id) {
        return false;
    }

    /**
     * Override this for receiving callbacks when a group has been collapsed.
     */
    @Override
    public void onGroupCollapse(final int groupPosition) {
    }

    /**
     * Override this for receiving callbacks when a group has been expanded.
     */
    @Override
    public void onGroupExpand(final int groupPosition) {
    }

//    /**
//     * Ensures the expandable list view has been created before Activity restores all
//     * of the view states.
//     *
//     *@see Activity#onRestoreInstanceState(Bundle)
//     */
//    @Override
//    protected void onRestoreInstanceState(Bundle state) {
//        ensureList();
//        super.onRestoreInstanceState(state);
//    }

    /**
     * Updates the screen state (current list and other views) when the
     * content changes.
     *
     * @see android.app.Activity#onContentChanged()
     */

    @SuppressWarnings("ConstantConditions")
    public void onContentChanged() {
//        super.onContentChanged();
        final View tmpEmptyView = getView().findViewById(android.R.id.empty);
        this.expandableList = (ExpandableListView) getView().findViewById(android.R.id.list);
        if (this.expandableList == null) {
            throw new RuntimeException(
                    "Your content must have a ExpandableListView whose id attribute is " +
                            "'android.R.id.list'");
        }
        if (tmpEmptyView != null) {
            this.expandableList.setEmptyView(tmpEmptyView);
        }
        this.expandableList.setOnChildClickListener(this);
        this.expandableList.setOnGroupExpandListener(this);
        this.expandableList.setOnGroupCollapseListener(this);

        if (this.finishedStart) {
            setListAdapter(this.listAdapter);
        }
        this.finishedStart = true;
    }

    /**
     * Get the activity's expandable list view widget.  This can be used to get the selection,
     * set the selection, and many other useful functions.
     *
     * @see ExpandableListView
     */
    public ExpandableListView getExpandableListView() {
        ensureList();
        return this.expandableList;
    }

    /**
     * Get the ExpandableListAdapter associated with this activity's
     * ExpandableListView.
     */
    public ExpandableListAdapter getExpandableListAdapter() {
        return this.listAdapter;
    }

    /**
     * Gets the ID of the currently selected group or child.
     *
     * @return The ID of the currently selected group or child.
     */
    public long getSelectedId() {
        return this.expandableList.getSelectedId();
    }

    /**
     * Gets the position (in packed position representation) of the currently
     * selected group or child. Use
     * {@link ExpandableListView#getPackedPositionType},
     * {@link ExpandableListView#getPackedPositionGroup}, and
     * {@link ExpandableListView#getPackedPositionChild} to unpack the returned
     * packed position.
     *
     * @return A packed position representation containing the currently
     *         selected group or child's position and type.
     */
    public long getSelectedPosition() {
        return this.expandableList.getSelectedPosition();
    }

    /**
     * Sets the selection to the specified child. If the child is in a collapsed
     * group, the group will only be expanded and child subsequently selected if
     * shouldExpandGroup is set to true, otherwise the method will return false.
     *
     * @param groupPosition     The position of the group that contains the child.
     * @param childPosition     The position of the child within the group.
     * @param shouldExpandGroup Whether the child's group should be expanded if
     *                          it is collapsed.
     * @return Whether the selection was successfully set on the child.
     */
    public boolean putSelectedChild(final int groupPosition, final int childPosition, final boolean shouldExpandGroup) {
        return this.expandableList.setSelectedChild(groupPosition, childPosition, shouldExpandGroup);
    }

    /**
     * Sets the selection to the specified group.
     *
     * @param groupPosition The position of the group that should be selected.
     */
    public void setSelectedGroup(final int groupPosition) {
        this.expandableList.setSelectedGroup(groupPosition);
    }
}