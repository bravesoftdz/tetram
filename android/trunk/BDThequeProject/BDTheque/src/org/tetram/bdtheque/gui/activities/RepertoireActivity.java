package org.tetram.bdtheque.gui.activities;

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.app.SearchManager;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.*;
import android.widget.*;
import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.Shakespeare;
import org.tetram.bdtheque.UserConfig;
import org.tetram.bdtheque.data.dao.*;
import org.tetram.bdtheque.gui.adapter.MenuAdapter;
import org.tetram.bdtheque.gui.adapter.MenuEntry;
import org.tetram.bdtheque.gui.adapter.RepertoireAdapter;
import org.tetram.bdtheque.gui.utils.ExpandableListFragment;

import java.util.ArrayList;
import java.util.List;

public class RepertoireActivity extends Activity implements ActionBar.OnNavigationListener {

    private static final int REQUEST_CONFIG = 0;

    private static final int REPERTOIRE_ALBUMS_TITRE = 10;
    private static final int REPERTOIRE_ALBUMS_SERIE = 11;
    private static final int REPERTOIRE_ALBUMS_EDITEUR = 12;
    private static final int REPERTOIRE_ALBUMS_GENRE = 13;
    private static final int REPERTOIRE_ALBUMS_ANNEE = 14;
    private static final int REPERTOIRE_ALBUMS_COLLECTION = 15;
    private static final int REPERTOIRE_SERIES = 20;
    private static final int REPERTOIRE_AUTEURS = 30;

    private int currentNavigationItem;
    private ShareActionProvider shareProvider;
    private TitlesFragment repertoire;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.consultation);

        repertoire = (TitlesFragment) getFragmentManager().findFragmentById(R.id.titles);

        if (savedInstanceState != null) {
            currentNavigationItem = savedInstanceState.getInt("navigationItem", 0);
        }

        List<MenuEntry> menuEntries = new ArrayList<MenuEntry>();
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsTitre), REPERTOIRE_ALBUMS_TITRE));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsSerie), REPERTOIRE_ALBUMS_SERIE));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsEditeur), REPERTOIRE_ALBUMS_EDITEUR));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsGenre), REPERTOIRE_ALBUMS_GENRE));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsAnnee), REPERTOIRE_ALBUMS_ANNEE));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAlbumsCollection), REPERTOIRE_ALBUMS_COLLECTION));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireSeries), REPERTOIRE_SERIES));
        menuEntries.add(new MenuEntry(getString(R.string.menuRepertoireAuteurs), REPERTOIRE_AUTEURS));

        MenuAdapter mSpinnerAdapter = new MenuAdapter(this, android.R.layout.simple_spinner_dropdown_item, menuEntries);

        ActionBar actionBar = getActionBar();
        actionBar.setTitle("");
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_LIST);
        actionBar.setListNavigationCallbacks(mSpinnerAdapter, this);
        actionBar.setSelectedNavigationItem(0);

        UserConfig.getInstance().reloadConfig(this);
        handleIntent(getIntent());
    }

    @Override
    protected void onSaveInstanceState(@NotNull Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("navigationItem", currentNavigationItem);
    }

    @Override
    public boolean onNavigationItemSelected(int position, long itemId) {
        currentNavigationItem = position;
        repertoire.setRepertoireMode((int) itemId);
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

    private void handleIntent(Intent intent) {
        if (Intent.ACTION_VIEW.equals(intent.getAction())) {
            // handles a click on a search suggestion; launches activity to show word
            /*
            Intent wordIntent = new Intent(this, WordActivity.class);
            wordIntent.setData(intent.getData());
            startActivity(wordIntent);
            */
        } else if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
            // handles a search query
            String query = intent.getStringExtra(SearchManager.QUERY);
            Toast.makeText(this, query, Toast.LENGTH_LONG).show();
            // showResults(query);
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.options_menu, menu);

        shareProvider = (ShareActionProvider) menu.findItem(R.id.menu_share).getActionProvider();
        shareProvider.setShareHistoryFileName(ShareActionProvider.DEFAULT_SHARE_HISTORY_FILE_NAME);
        shareProvider.setShareIntent(CreateShareIntent());

        return super.onCreateOptionsMenu(menu);
    }

    public Intent CreateShareIntent() {
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
                shareProvider.setShareIntent(CreateShareIntent());
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
                repertoire.setRepertoireMode(currentNavigationItem);
                break;
        }
    }

    /**
     * This is a secondary activity, to show what the user has selected
     * when the screen is not large enough to show it all in one activity.
     */
    public static class FicheActivity extends Activity {

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
        boolean mDualPane;
        int mCurCheckPosition = 0;

        InitialeRepertoireDao<?, ?> dao;
        private int repertoireMode;

        @Override
        public void onActivityCreated(Bundle savedInstanceState) {
            super.onActivityCreated(savedInstanceState);
            if (savedInstanceState != null) {
                // Restore last state for checked position.
                mCurCheckPosition = savedInstanceState.getInt("curChoice", 0);
            }
        }

        @Override
        public void onSaveInstanceState(Bundle outState) {
            super.onSaveInstanceState(outState);
            outState.putInt("curChoice", mCurCheckPosition);
        }

        @Override
        public void onListItemClick(ExpandableListView l, View v, int position, long id) {
            showDetails(position);
        }

        /**
         * Helper function to show the details of a selected item, either by
         * displaying a fragment in-place in the current UI, or starting a
         * whole new activity in which it is displayed.
         */
        void showDetails(int index) {
            mCurCheckPosition = index;
/*
            if (mDualPane) {
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

        public void setRepertoireMode(int repertoireMode) {
            if (this.repertoireMode != repertoireMode)
                mCurCheckPosition = 0;
            this.repertoireMode = repertoireMode;
            switch (this.repertoireMode) {
                case REPERTOIRE_ALBUMS_TITRE:
                    dao = new AlbumLiteDao(getActivity());
                    break;
                case REPERTOIRE_ALBUMS_SERIE:
                    dao = new AlbumLiteSerieDao(getActivity());
                    break;
                case REPERTOIRE_ALBUMS_EDITEUR :
                    dao = new AlbumLiteEditeurDao(getActivity());
                    break;
                case REPERTOIRE_ALBUMS_GENRE :
                    dao = new AlbumLiteGenreDao(getActivity());
                    break;
                case REPERTOIRE_ALBUMS_ANNEE :
                    dao = new AlbumLiteAnneeDao(getActivity());
                    break;
                case REPERTOIRE_ALBUMS_COLLECTION :
                    dao = new AlbumLiteCollectionDao(getActivity());
                    break;
                case REPERTOIRE_SERIES:
                    dao = new SerieLiteDao(getActivity());
                    break;
                case REPERTOIRE_AUTEURS:
                    dao = new AuteurLiteDao(getActivity());
                    break;
            }

            // Populate list with our static array of titles.
            setListAdapter(new RepertoireAdapter(getActivity(), dao));

            // Check to see if we have a frame in which to embed the details
            // fragment directly in the containing UI.
            View detailsFrame = getActivity().findViewById(R.id.details);
            mDualPane = detailsFrame != null && detailsFrame.getVisibility() == View.VISIBLE;

            if (mDualPane) {
                // In dual-pane mode, the list view highlights the selected item.
                getListView().setChoiceMode(ListView.CHOICE_MODE_SINGLE);
                // Make sure our UI is in the correct state.
                showDetails(mCurCheckPosition);
            }
        }

        public int getRepertoireMode() {
            return repertoireMode;
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
        public static FicheFragment newInstance(int index) {
            FicheFragment f = new FicheFragment();

            // Supply index input as an argument.
            Bundle args = new Bundle();
            args.putInt("index", index);
            f.setArguments(args);

            return f;
        }

        public int getShownIndex() {
            return getArguments().getInt("index", 0);
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
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