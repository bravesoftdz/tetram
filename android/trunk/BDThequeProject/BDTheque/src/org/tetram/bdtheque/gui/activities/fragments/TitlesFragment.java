package org.tetram.bdtheque.gui.activities.fragments;

import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;
import android.widget.Toast;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.data.factories.DaoFactory;
import org.tetram.bdtheque.gui.activities.FicheActivity;
import org.tetram.bdtheque.gui.adapter.RepertoireAdapter;
import org.tetram.bdtheque.gui.utils.ModeRepertoire;

public class TitlesFragment extends ExpandableListFragment {
    boolean dualPane;
    int curCheckPosition;

    private InitialeRepertoireDao<?, ?> repertoireDao;
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
    public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
        // Toast.makeText(this.getActivity(), String.format("onChildClick(groupPosition: %d, childPosition: %d, id: %d)", groupPosition, childPosition, id), Toast.LENGTH_LONG).show();

        Object selectedItem = getExpandableListAdapter().getChild(groupPosition, childPosition);
        Toast.makeText(this.getActivity(), String.format("%s: %s", selectedItem.getClass().getSimpleName(), ((CommonBean) selectedItem).getId().toString()), Toast.LENGTH_LONG).show();
        //showDetails(position);
        return true;
    }

    /**
     * Helper function to show the details of a selected item, either by
     * displaying a fragments in-place in the current UI, or starting a
     * whole new activity in which it is displayed.
     */
    void showDetails(int index) {
        this.curCheckPosition = index;

        if (this.dualPane) {
            // We can display everything in-place with fragments, so update
            // the list to highlight the selected item and show the database.
            getExpandableListView().setItemChecked(index, true);

            // Check what fragments is currently shown, replace if needed.
            FicheFragment details = (FicheFragment) getFragmentManager().findFragmentById(R.id.details);
            if ((details == null) || (details.getShownIndex() != index)) {
                // Make new fragments to show this selection.
                details = FicheFragment.newInstance(index);

                // Execute a transaction, replacing any existing fragments
                // with this one inside the frame.
                FragmentTransaction ft = getFragmentManager().beginTransaction();
                ft.replace(R.id.details, details);
                ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
                ft.commit();
            }

        } else {
            // Otherwise we need to launch a new activity to display
            // the dialog fragments with selected text.
            Intent intent = new Intent();
            intent.setClass(getActivity(), FicheActivity.class);
            intent.putExtra("index", index);
            startActivity(intent);
        }
    }

    public void setRepertoireMode(ModeRepertoire repertoireMode) {
        if (this.repertoireMode != repertoireMode)
            this.curCheckPosition = 0;
        this.repertoireMode = repertoireMode;
        this.setRepertoireDao(DaoFactory.getDao(repertoireMode.getDaoClass(), getActivity()));

        refreshList();
    }

    public void refreshList() {
        setListAdapter(new RepertoireAdapter(getActivity(), this.getRepertoireDao()));
        onContentChanged();

        // Check to see if we have a frame in which to embed the details
        // fragments directly in the containing UI.
        View detailsFrame = getActivity().findViewById(R.id.details);
        this.dualPane = (detailsFrame != null) && (detailsFrame.getVisibility() == View.VISIBLE);

        if (this.dualPane) {
            // In dual-pane mode, the list view highlights the selected item.
            getExpandableListView().setChoiceMode(AbsListView.CHOICE_MODE_SINGLE);
            // Make sure our UI is in the correct state.
            showDetails(this.curCheckPosition);
        }
    }

    @SuppressWarnings("UnusedDeclaration")
    public ModeRepertoire getRepertoireMode() {
        return this.repertoireMode;
    }

    public InitialeRepertoireDao<?, ?> getRepertoireDao() {
        return this.repertoireDao;
    }

    public void setRepertoireDao(InitialeRepertoireDao<?, ?> repertoireDao) {
        this.repertoireDao = repertoireDao;
    }
}
