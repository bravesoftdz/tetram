package org.tetram.bdtheque.gui.activities.fragments;

import android.app.Fragment;
import android.os.Bundle;
import android.os.Handler;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ListView;
import android.widget.SectionIndexer;
import android.widget.TextView;

import org.tetram.bdtheque.R;

/**
 * This class has originally been taken from
 * http://stackoverflow.com/questions/6051050/expandablelistfragment-with-loadermanager-for-compatibility-package
 * and then modified by Manfred Moser <manfred@simpligility.com> to get it to work with the v4 r4 compatibility
 * library. With inspirations from the library source.
 * <p/>
 * All ASLv2 licensed.
 */
@SuppressWarnings("UnusedDeclaration")
public class ExpandableListFragment extends Fragment implements
        ExpandableListView.OnChildClickListener,
        ExpandableListView.OnGroupCollapseListener,
        ExpandableListView.OnGroupExpandListener {

    // static final int INTERNAL_EMPTY_ID = 0x00ff0001;
    static final int INTERNAL_LIST_CONTAINER_ID = 0x00ff0003;

    private final Handler mHandler = new Handler();

    private final Runnable mRequestFocus = new Runnable() {
        @Override
        public void run() {
            ExpandableListFragment.this.expandableListView.focusableViewAvailable(ExpandableListFragment.this.expandableListView);
        }
    };

    private final AdapterView.OnItemClickListener mOnClickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            onListItemClick((ListView) parent, view, position, id);
        }
    };

    ExpandableListAdapter expandableListAdapter;
    ExpandableListView expandableListView;
    View mEmptyView;
    TextView mStandardEmptyView;
    View listContainer;
    boolean mSetEmptyText;
    boolean mListShown;
    boolean mFinishedStart;

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
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
/*
        FrameLayout root = new FrameLayout(getActivity());

        FrameLayout lframe = new FrameLayout(getActivity());
        lframe.setId(INTERNAL_LIST_CONTAINER_ID);

        TextView tv = new TextView(getActivity());
        tv.setId(INTERNAL_EMPTY_ID);
        tv.setGravity(Gravity.CENTER);
        lframe.addView(tv,
                new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        ExpandableListView lv = new ExpandableListView(getActivity());
        lv.setId(android.R.id.list);
        lv.setDrawSelectorOnTop(false);
        lframe.addView(lv,
                new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        root.addView(lframe, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        ListView.LayoutParams lp =
                new ListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        root.setLayoutParams(lp);

        return root;
*/
        return inflater.inflate(R.layout.treeview, container);
    }

    /**
     * Attach to list view once the view hierarchy has been created.
     */
    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ensureList();
    }

    /**
     * Detach from list view.
     */
    @Override
    public void onDestroyView() {
        this.mHandler.removeCallbacks(this.mRequestFocus);
        this.expandableListView = null;
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
    public void onListItemClick(ListView listView, View view, int position, long id) {
    }

    /**
     * Provide the cursor for the list view.
     */
    public void setListAdapter(ExpandableListAdapter adapter) {
        boolean hadAdapter = this.expandableListAdapter != null;
        this.expandableListAdapter = adapter;
        if (this.expandableListView != null) {
            this.expandableListView.setAdapter(adapter);
            this.expandableListView.setFastScrollEnabled(adapter instanceof SectionIndexer);
            if (!this.mListShown && !hadAdapter) {
                // The list was hidden, and previously didn't have an
                // adapter.  It is now time to show it.
                setListShown(true, getView().getWindowToken() != null);
            }
        }
    }

    /**
     * Set the currently selected list item to the specified
     * position with the adapter's data
     */
    public void setSelection(int position) {
        ensureList();
        this.expandableListView.setSelection(position);
    }

    public long getSelectedPosition() {
        ensureList();
        return this.expandableListView.getSelectedPosition();
    }

    public long getSelectedId() {
        ensureList();
        return this.expandableListView.getSelectedId();
    }

    public ExpandableListView getExpandableListView() {
        ensureList();
        return this.expandableListView;
    }

    /**
     * The default content for a ListFragment has a TextView that can
     * be shown when the list is empty.  If you would like to have it
     * shown, call this method to supply the text it should use.
     */
/*
    public void setEmptyText(CharSequence text) {
        ensureList();
        if (this.mStandardEmptyView == null) {
            throw new IllegalStateException("Can't be used with a custom content view");
        }
        this.mStandardEmptyView.setText(text);
        if (!this.mSetEmptyText) {
            this.expandableListView.setEmptyView(this.mStandardEmptyView);
            this.mSetEmptyText = true;
        }
    }
*/

    /**
     * Control whether the list is being displayed.  You can make it not
     * displayed if you are waiting for the initial data to show in it.  During
     * this time an indeterminant progress indicator will be shown instead.
     * <p/>
     * <p>Applications do not normally need to use this themselves.  The default
     * behavior of ListFragment is to start with the list not being shown, only
     * showing it once an adapter is given with {@link #setListAdapter(android.widget.ExpandableListAdapter)}.
     * If the list at that point had not been shown, when it does get shown
     * it will be do without the user ever seeing the hidden state.
     *
     * @param shown If true, the list view is shown; if false, the progress
     *              indicator.  The initial value is true.
     */
    public void setListShown(boolean shown) {
        setListShown(shown, true);
    }

    /**
     * Like {@link #setListShown(boolean)}, but no animation is used when
     * transitioning from the previous state.
     */
    public void setListShownNoAnimation(boolean shown) {
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
    private void setListShown(boolean shown, boolean animate) {
        ensureList();
        if (this.mListShown == shown) {
            return;
        }
        this.mListShown = shown;
        if (this.listContainer != null) {
            if (shown) {
                if (animate)
                    this.listContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_in));
                this.listContainer.setVisibility(View.VISIBLE);
            } else {
                if (animate)
                    this.listContainer.startAnimation(AnimationUtils.loadAnimation(getActivity(), android.R.anim.fade_out));
                this.listContainer.setVisibility(View.GONE);
            }
        }
    }

    /**
     * Get the ListAdapter associated with this activity's ListView.
     */
    public ExpandableListAdapter getExpandableListAdapter() {
        return this.expandableListAdapter;
    }

    @SuppressWarnings("VariableNotUsedInsideIf")
    private void ensureList() {
        if (this.expandableListView != null) {
            return;
        }
        View root = getView();
        if (root == null) {
            throw new IllegalStateException("Content view not yet created");
        }
        if (root instanceof ExpandableListView) {
            this.expandableListView = (ExpandableListView) root;
        } else {
            //this.mStandardEmptyView = (TextView) root.findViewById(INTERNAL_EMPTY_ID);
            //if (this.mStandardEmptyView == null) {
            this.mEmptyView = root.findViewById(android.R.id.empty);
            //}
            View rawListView = root.findViewById(android.R.id.list);
            if (!(rawListView instanceof ExpandableListView)) {
                if (rawListView == null) {
                    throw new RuntimeException("Your content must have a ExpandableListView whose id attribute is " +
                            "'android.R.id.list'");
                }
                throw new RuntimeException("Content has view with id attribute 'android.R.id.list' " +
                        "that is not a ExpandableListView class");
            }
            this.expandableListView = (ExpandableListView) rawListView;
            this.listContainer = (View) this.expandableListView.getParent();
            if (this.mEmptyView != null) {
                this.expandableListView.setEmptyView(this.mEmptyView);
            }
        }
        this.mListShown = true;
        this.expandableListView.setOnItemClickListener(this.mOnClickListener);
        if (this.expandableListAdapter != null) {
            setListAdapter(this.expandableListAdapter);
        } else {
            // We are starting without an adapter, so assume we won't
            // have our data right away and start with the progress indicator.
            setListShown(false, false);
        }
        this.mHandler.post(this.mRequestFocus);
    }

    @Override
    public void onGroupExpand(int groupPosition) {
    }

    @Override
    public void onGroupCollapse(int groupPosition) {
    }

    @Override
    public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
        this.mOnClickListener.onItemClick(parent, v, childPosition, id);
        return false;
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo) {
    }

    public void onContentChanged() {
        if (getView() == null) return;
        View emptyView = getView().findViewById(android.R.id.empty);
        this.expandableListView = (ExpandableListView) getView().findViewById(android.R.id.list);
        if (this.expandableListView == null) {
            throw new RuntimeException(
                    "Your content must have a ExpandableListView whose id attribute is 'android.R.id.list'");
        }
        if (emptyView != null) {
            this.expandableListView.setEmptyView(emptyView);
        }
        this.expandableListView.setOnChildClickListener(this);
        this.expandableListView.setOnGroupExpandListener(this);
        this.expandableListView.setOnGroupCollapseListener(this);

        if (this.mFinishedStart) {
            setListAdapter(this.expandableListAdapter);
        }
        this.mFinishedStart = true;
    }
}