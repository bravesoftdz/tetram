package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.PersonneBean;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

public class FichePersonneDetailsFragment extends FicheFragment {

    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        PersonneBean bean = getArguments().getParcelable("bean");

        View v = inflater.inflate(R.layout.fiche_personne_details_fragment, container, false);

        setUIElement(v, R.id.personne_nom, StringUtils.formatTitre(bean.getNom()));
        setUIElement(v, R.id.personne_biographie, bean.getBiographie());

        return v;
    }
}
