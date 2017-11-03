package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.gui.components.LinearListView;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

@SuppressWarnings("UnusedDeclaration")
public class FicheSerieDetailsFragment extends FicheFragment {

    @SuppressWarnings("MagicConstant")
    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        final SerieBean serie = getArguments().getParcelable("bean");
        if (serie == null) return null;

        View v = inflater.inflate(R.layout.fiche_serie_details_fragment, container, false);

        if (serie.getNotation() != null)
            ((ImageView) v.findViewById(R.id.serie_notation)).setImageResource(serie.getNotation().getResDrawable());
        setUIElementURL(v, R.id.serie_titre, StringUtils.formatTitreAcceptNull(serie.getTitre()), serie.getSiteWeb(), 0);
        final EditeurBean editeur = serie.getEditeur();
        setUIElementURL(v, R.id.serie_editeur, StringUtils.formatTitreAcceptNull(editeur.getNom()), editeur.getSiteWeb(), 0);
        final CollectionLiteBean collection = serie.getCollection();
        if (collection == null)
            v.findViewById(R.id.fiche_serie_row_collection).setVisibility(View.GONE);
        else
            setUIElement(v, R.id.serie_collection, StringUtils.formatTitreAcceptNull(collection.getNom()));
        setUIElement(v, R.id.serie_genres, serie.getGenreList(), R.id.fiche_serie_row_genres);

        LinearListView listAuteurs;

        if (serie.getScenaristes().isEmpty())
            v.findViewById(R.id.fiche_serie_row_scenaristes).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.serie_scenaristes);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, serie.getScenaristes()));
        //listAuteurs.setMinimumHeight(Math.min(serie.getScenaristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        if (serie.getDessinateurs().isEmpty())
            v.findViewById(R.id.fiche_serie_row_dessinateurs).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.serie_dessinateurs);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, serie.getDessinateurs()));
        //listAuteurs.setMinimumHeight(Math.min(serie.getDessinateurs().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        if (serie.getColoristes().isEmpty())
            v.findViewById(R.id.fiche_serie_row_coloristes).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.serie_coloristes);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, serie.getColoristes()));
        //listAuteurs.setMinimumHeight(Math.min(serie.getColoristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        setUIElement(v, R.id.serie_histoire, serie.getSujet(), R.id.fiche_serie_row_histoire);
        setUIElement(v, R.id.serie_notes, serie.getNotes(), R.id.fiche_serie_row_notes);

        return v;
    }
}
