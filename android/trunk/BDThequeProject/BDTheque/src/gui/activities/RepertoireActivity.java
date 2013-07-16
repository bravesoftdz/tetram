package org.tetram.bdtheque.gui.activities;

import android.app.ActionBar;
import android.app.Activity;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.ShareActionProvider;

import org.jetbrains.annotations.NotNull;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.gui.adapters.MenuAdapter;
import org.tetram.bdtheque.gui.adapters.MenuEntry;
import org.tetram.bdtheque.gui.fragments.TitlesFragment;
import org.tetram.bdtheque.gui.utils.ModeRepertoire;
import org.tetram.bdtheque.utils.UserConfig;

import java.util.ArrayList;
import java.util.List;

public class RepertoireActivity extends Activity implements ActionBar.OnNavigationListener, SearchManager.OnCancelListener {

    private static final int REQUEST_CONFIG = 0;

    private int currentNavigationItem = -1;
    private ShareActionProvider shareProvider;
    private TitlesFragment repertoire;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repertoire);

        this.repertoire = (TitlesFragment) getFragmentManager().findFragmentById(R.id.titles);

        if (savedInstanceState != null) {
            this.currentNavigationItem = savedInstanceState.getInt("navigationItem", -1);
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
        if (this.currentNavigationItem > -1)
            actionBar.setSelectedNavigationItem(this.currentNavigationItem);
        else if (defaultMenu != null)
            actionBar.setSelectedNavigationItem(menuEntries.indexOf(defaultMenu));
        else
            actionBar.setSelectedNavigationItem(0);

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
        if (Intent.ACTION_VIEW.equals(s)) {
            // handles a click on a search suggestion; launches activity to show word
            /*
            Intent wordIntent = new Intent(this, WordActivity.class);
            wordIntent.setData(intent.getData());
            startActivity(wordIntent);
            */
        } else if (Intent.ACTION_SEARCH.equals(s)) {
            this.repertoire.getRepertoireDao().setFiltre(intent.getStringExtra(SearchManager.QUERY));
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
        if ("".equals(this.repertoire.getRepertoireDao().getFiltre())) return;
        this.repertoire.getRepertoireDao().setFiltre(null);
        this.repertoire.refreshList();
    }

}