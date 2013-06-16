package org.tetram.bdtheque.gui.activities;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.*;
import android.widget.*;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.Shakespeare;
import org.tetram.bdtheque.UserConfig;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.data.factories.DaoFactory;
import org.tetram.bdtheque.gui.adapter.MenuAdapter;
import org.tetram.bdtheque.gui.adapter.MenuEntry;
import org.tetram.bdtheque.gui.adapter.RepertoireAdapter;
import org.tetram.bdtheque.gui.utils.ExpandableListFragment;
import org.tetram.bdtheque.gui.utils.ModeRepertoire;

import java.util.ArrayList;
import java.util.List;

public class RepertoireActivity extends Activity implements ActionBar.OnNavigationListener, SearchManager.OnCancelListener {

    private static final int REQUEST_CONFIG = 0;

    private int currentNavigationItem;
    private ShareActionProvider shareProvider;
    private TitlesFragment repertoire;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.consultation);

        this.repertoire = (TitlesFragment) getFragmentManager().findFragmentById(R.id.titles);

        if (savedInstanceState != null) {
            this.currentNavigationItem = savedInstanceState.getInt("navigationItem", 0);
        }

        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        searchManager.setOnCancelListener(this);

        MenuEntry defaultMenu = null;
        List<MenuEntry> menuEntries = new ArrayList<>();
        for (ModeRepertoire mode : ModeRepertoire.values()) {
            MenuEntry menu = mode.getMenuEntry(this);
            if (mode.isDefault()) defaultMenu = menu;
            menuEntries.add(menu);
        }

        MenuAdapter mSpinnerAdapter = new MenuAdapter(this, android.R.layout.simple_spinner_dropdown_item, menuEntries);

        ActionBar actionBar = getActionBar();
        actionBar.setTitle("");
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_LIST);
        actionBar.setListNavigationCallbacks(mSpinnerAdapter, this);
        actionBar.setSelectedNavigationItem((defaultMenu == null) ? 0 : menuEntries.indexOf(defaultMenu));

        UserConfig.getInstance().reloadConfig(this);
        handleIntent(getIntent());
    }

    @Override
    protected void onSaveInstanceState(@NotNull Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("navigationItem", this.currentNavigationItem);
    }

    @Override
    public boolean onNavigationItemSelected(int itemPosition, long itemId) {
        this.currentNavigationItem = itemPosition;
        this.repertoire.setRepertoireMode(ModeRepertoire.values()[((int) itemId)]);
        return true;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        // Because this activity has set launchMode="singleTop", the system calls this method
        // to deliver the intent if this activity is currently the foreground activity when
        // invoked again (when the user executes a search from this activity, we don't create
        // a new instance of this activity, so the system delivers the search intent here)
        handleIntent(intent);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    private void handleIntent(Intent intent) {
        String s = intent.getAction();
        if (s.equals(Intent.ACTION_VIEW)) {
            // handles a click on a search suggestion; launches activity to show word
            /*
            Intent wordIntent = new Intent(this, WordActivity.class);
            wordIntent.setData(intent.getData());
            startActivity(wordIntent);
            */
        } else if (s.equals(Intent.ACTION_SEARCH)) {
            this.repertoire.repertoireDao.setFiltre(intent.getStringExtra(SearchManager.QUERY));
            this.repertoire.refreshList();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.options_menu, menu);

        this.shareProvider = (ShareActionProvider) menu.findItem(R.id.menu_share).getActionProvider();
        this.shareProvider.setShareHistoryFileName(ShareActionProvider.DEFAULT_SHARE_HISTORY_FILE_NAME);
        this.shareProvider.setShareIntent(createShareIntent());

        return super.onCreateOptionsMenu(menu);
    }

    public static Intent createShareIntent() {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("plain/text");
        intent.putExtra(Intent.EXTRA_TEXT, "Test");
        return intent;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.search:
                onSearchRequested();
                return true;
            case R.id.menu_share:
                this.shareProvider.setShareIntent(createShareIntent());
                return true;
            case R.id.menu_options:
                startActivityForResult(new Intent(this, SettingsActivity.class), REQUEST_CONFIG);
                return true;
            default:
                return false;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        switch (requestCode) {
            case REQUEST_CONFIG:
                UserConfig.getInstance().reloadConfig(this);
                this.repertoire.refreshList();
                break;
        }
    }

    @Override
    public void onCancel() {
        if ("".equals(this.repertoire.repertoireDao.getFiltre())) return;
        this.repertoire.repertoireDao.setFiltre(null);
        this.repertoire.refreshList();
    }

    /**
     * This is a secondary activity, to show what the user has selected
     * when the screen is not large enough to show it all in one activity.
     */
    public static class FicheActivity extends Activity {

        @SuppressWarnings("VariableNotUsedInsideIf")
        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);

            if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
                // If the screen is now in landscape mode, we can show the
                // dialog in-line with the list so we don't need this activity.
                finish();
                return;
            }

            if (savedInstanceState == null) {
                // During initial setup, plug in the details fragment.
                FicheFragment details = new FicheFragment();
                details.setArguments(getIntent().getExtras());
                getFragmentManager().beginTransaction().add(android.R.id.content, details).commit();
            }
        }
    }

    /**
     * This is the "top-level" fragment, showing a list of items that the
     * user can pick.  Upon picking an item, it takes care of displaying the
     * database to the user as appropriate based on the currrent UI layout.
     */
    public static class TitlesFragment extends ExpandableListFragment {
        boolean dualPane;
        int curCheckPosition;

        InitialeRepertoireDao<?, ?> repertoireDao;
        private ModeRepertoire repertoireMode;

        @Override
        public void onActivityCreated(Bundle savedInstanceState) {
            super.onActivityCreated(savedInstanceState);
            if (savedInstanceState != null) {
                // Restore last state for checked position.
                this.curCheckPosition = savedInstanceState.getInt("curChoice", 0);
            }
        }

        @Override
        public void onSaveInstanceState(Bundle outState) {
            super.onSaveInstanceState(outState);
            outState.putInt("curChoice", this.curCheckPosition);
        }

        @Override
        public void onListItemClick(ExpandableListView listView, View view, int position, long id) {
            showDetails(position);
        }

        /**
         * Helper function to show the details of a selected item, either by
         * displaying a fragment in-place in the current UI, or starting a
         * whole new activity in which it is displayed.
         */
        void showDetails(int index) {
            this.curCheckPosition = index;
/*
            if (dualPane) {
                // We can display everything in-place with fragments, so update
                // the list to highlight the selected item and show the database.
                getListView().setItemChecked(index, true);

                // Check what fragment is currently shown, replace if needed.
                FicheFragment details = (FicheFragment) getFragmentManager().findFragmentById(R.id.details);
                if (details == null || details.getShownIndex() != index) {
                    // Make new fragment to show this selection.
                    details = FicheFragment.newInstance(index);

                    // Execute a transaction, replacing any existing fragment
                    // with this one inside the frame.
                    FragmentTransaction ft = getFragmentManager().beginTransaction();
                    ft.replace(R.id.details, details);
                    ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
                    ft.commit();
                }

            } else {
                // Otherwise we need to launch a new activity to display
                // the dialog fragment with selected text.
                Intent intent = new Intent();
                intent.setClass(getActivity(), FicheActivity.class);
                intent.putExtra("index", index);
                startActivity(intent);
            }
 */
        }

        public void setRepertoireMode(ModeRepertoire repertoireMode) {
            if (this.repertoireMode != repertoireMode)
                this.curCheckPosition = 0;
            this.repertoireMode = repertoireMode;
            this.repertoireDao = DaoFactory.getDao(repertoireMode.getDaoClass(), getActivity());

            refreshList();
        }

        private void refreshList() {
            setListAdapter(new RepertoireAdapter(getActivity(), this.repertoireDao));

            // Check to see if we have a frame in which to embed the details
            // fragment directly in the containing UI.
            View detailsFrame = getActivity().findViewById(R.id.details);
            this.dualPane = detailsFrame != null && detailsFrame.getVisibility() == View.VISIBLE;

            if (this.dualPane) {
                // In dual-pane mode, the list view highlights the selected item.
                getListView().setChoiceMode(AbsListView.CHOICE_MODE_SINGLE);
                // Make sure our UI is in the correct state.
                showDetails(this.curCheckPosition);
            }
        }

        @SuppressWarnings("UnusedDeclaration")
        public ModeRepertoire getRepertoireMode() {
            return this.repertoireMode;
        }
    }


    /**
     * This is the secondary fragment, displaying the details of a particular
     * item.
     */

    public static class FicheFragment extends Fragment {
        /**
         * Create a new instance of FicheFragment, initialized to
         * show the text at 'index'.
         */
        @SuppressWarnings("UnusedDeclaration")
        public static FicheFragment newInstance(int index) {
            FicheFragment ficheFragment = new FicheFragment();

            // Supply index input as an argument.
            Bundle args = new Bundle();
            args.putInt("index", index);
            ficheFragment.setArguments(args);

            return ficheFragment;
        }

        public int getShownIndex() {
            return getArguments().getInt("index", 0);
        }

        @Nullable
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
            if (container == null) {
                // We have different layouts, and in one of them this
                // fragment's containing frame doesn't exist.  The fragment
                // may still be created from its saved state, but there is
                // no reason to try to create its view hierarchy because it
                // won't be displayed.  Note this is not needed -- we could
                // just run the code below, where we would create and return
                // the view hierarchy; it would just never be used.
                return null;
            }

            ScrollView scroller = new ScrollView(getActivity());
            TextView text = new TextView(getActivity());
            int padding = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4, getActivity().getResources().getDisplayMetrics());
            text.setPadding(padding, padding, padding, padding);
            scroller.addView(text);
            text.setText(Shakespeare.DIALOGUE[getShownIndex()]);
            return scroller;
        }
    }

}