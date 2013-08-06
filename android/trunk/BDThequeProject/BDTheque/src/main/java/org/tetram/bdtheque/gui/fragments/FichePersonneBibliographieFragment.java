package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ExpandableListView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.dao.lite.BibliographieDao;
import org.tetram.bdtheque.gui.adapters.RepertoireAdapter;

public class FichePersonneBibliographieFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        PersonneBean bean = getArguments().getParcelable("bean");

        View view = inflater.inflate(R.layout.fiche_personne_bibliographie_fragment, container, false);

        ExpandableListView listBibliographie = (ExpandableListView) view.findViewById(R.id.personne_bibliographie);
        final BibliographieDao dao = DaoFactory.getDao(BibliographieDao.class);
        dao.setPersonne(bean);
        listBibliographie.setAdapter(new RepertoireAdapter(getActivity(), dao));
        listBibliographie.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView parent, View v, int groupPosition, int childPosition, long id) {
                CommonBean commonBean = (CommonBean) parent.getExpandableListAdapter().getChild(groupPosition, childPosition);
                TitlesFragment titlesFragment = (TitlesFragment) getFragmentManager().findFragmentById(R.id.titles);
                titlesFragment.showDetails(commonBean);
                return true;
            }
        });

        return view;
    }

}
