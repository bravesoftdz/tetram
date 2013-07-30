package org.tetram.bdtheque.gui.fragments;

import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ExpandableListView;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.gui.activities.FicheActivity;
import org.tetram.bdtheque.gui.adapters.RepertoireAdapter;
import org.tetram.bdtheque.gui.utils.ModeRepertoire;
import org.tetram.bdtheque.gui.utils.ShowFragmentClass;

public class TitlesFragment extends ExpandableListFragment {
    Integer curChildPosition, curGroupPosition;

    private InitialeRepertoireDao<?, ?> repertoireDao;
    private ModeRepertoire repertoireMode;
    private boolean synchroScroll;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        if (savedInstanceState != null) {
            // Restore last state for checked position.
            this.repertoireMode = (ModeRepertoire) savedInstanceState.getSerializable("repertoireMode");
            this.curGroupPosition = (Integer) savedInstanceState.get("curGroupPosition");
            this.curChildPosition = (Integer) savedInstanceState.get("curChildPosition");
            this.synchroScroll = true;
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putSerializable("repertoireMode", this.repertoireMode);
        if (this.curGroupPosition != null)
            outState.putInt("curGroupPosition", this.curGroupPosition);
        if (this.curChildPosition != null)
            outState.putInt("curChildPosition", this.curChildPosition);
    }

    @Override
    public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
        showDetails(groupPosition, childPosition);
        return true;
    }

    /**
     * Helper function to show the details of a selected item, either by
     * displaying a fragments in-place in the current UI, or starting a
     * whole new activity in which it is displayed.
     */
    void showDetails(Integer groupPosition, Integer childPosition) {
        this.curGroupPosition = groupPosition;
        this.curChildPosition = childPosition;

        if ((groupPosition == null) || (childPosition == null)) return;

        CommonBean bean = (CommonBean) getExpandableListAdapter().getChild(groupPosition, childPosition);

        // We can display everything in-place with fragments, so update
        // the list to highlight the selected item and show the org.tetram.bdtheque.database.
        if (this.synchroScroll) {
            this.expandableListView.expandGroup(groupPosition, false);
            this.expandableListView.setSelectedChild(groupPosition, childPosition, true);
            this.synchroScroll = false;
        }

        showDetails(bean);
    }

    void showDetails(CommonBean bean) {
        if (BDThequeApplication.getInstance().isRepertoireDualPanel()) {
            // Check what fragments is currently shown, replace if needed.
            FicheFragment details = (FicheFragment) getFragmentManager().findFragmentById(R.id.details);
            if ((details == null) || (!details.getShownId().equals(bean.getId()))) {
                // Execute a transaction, replacing any existing fragments
                // with this one inside the frame.
                FragmentTransaction ft = getFragmentManager().beginTransaction();

                // Make new fragments to show this selection.
                ShowFragmentClass a = bean.getClass().getAnnotation(ShowFragmentClass.class);
                if (a == null) return;

                ft.replace(R.id.details, FicheFragment.newInstance(a.value(), bean)).addToBackStack(null);
                ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
                ft.commit();
            }
        } else {
            // Otherwise we need to launch a new activity to display
            // the dialog fragments with selected text.
            Intent intent = new Intent();
            intent.setClass(getActivity(), FicheActivity.class);
            intent.putExtra("bean", bean);
            startActivity(intent);
        }
    }

    public void setRepertoireMode(ModeRepertoire repertoireMode) {
        if (this.repertoireMode != repertoireMode) {
            this.curGroupPosition = null;
            this.curChildPosition = null;
        }
        this.repertoireMode = repertoireMode;
        this.setRepertoireDao(DaoFactory.getRepertoireDao(repertoireMode.getDaoClass(), getActivity()));

        refreshList();
    }

    public void refreshList() {
        setListAdapter(new RepertoireAdapter(getActivity(), this.getRepertoireDao()));
        onContentChanged();

        if (this.curChildPosition != null) {
            if (BDThequeApplication.getInstance().isRepertoireDualPanel())
                this.expandableListView.setChoiceMode(AbsListView.CHOICE_MODE_SINGLE);
            showDetails(this.curGroupPosition, this.curChildPosition);
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
