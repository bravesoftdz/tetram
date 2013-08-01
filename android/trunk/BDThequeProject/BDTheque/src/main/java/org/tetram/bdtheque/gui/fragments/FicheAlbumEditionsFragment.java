package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.UserConfig;

import java.util.Date;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

public class FicheAlbumEditionsFragment extends FicheFragment {

    @SuppressWarnings("FieldCanBeLocal")
    private EditionBean currentEdition;
    private View view;

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable("bean");
        if (album == null) return null;

        this.view = inflater.inflate(R.layout.fiche_album_editions_fragment, container, false);

        Spinner listEditions = (Spinner) this.view.findViewById(R.id.album_list_editions);
        if (album.getEditions().size() <= 1) listEditions.setVisibility(View.GONE);
        listEditions.setAdapter(new ArrayAdapter<EditionBean>(getActivity(), android.R.layout.simple_list_item_1, album.getEditions()));
        listEditions.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                loadEdition((EditionBean) parent.getAdapter().getItem(position));
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        listEditions.setSelection(0);
        loadEdition((EditionBean) listEditions.getAdapter().getItem(0));

        return this.view;
    }

    private void loadEdition(EditionBean edition) {
        this.currentEdition = edition;
        setUIElement(this.view, R.id.edition_isbn, StringUtils.formatISBN(this.currentEdition.getIsbn()));

        final EditeurBean editeur = this.currentEdition.getEditeur();
        setUIElementURL(this.view, R.id.edition_editeur, StringUtils.formatTitreAcceptNull(editeur.getNom()), editeur.getSiteWeb(), 0);
        final CollectionLiteBean collection = this.currentEdition.getCollection();
        if (collection == null)
            this.view.findViewById(R.id.fiche_edition_row_collection).setVisibility(View.GONE);
        else
            setUIElement(this.view, R.id.edition_collection, StringUtils.formatTitreAcceptNull(collection.getNom()), R.id.fiche_edition_row_collection);

        setUIElement(this.view, R.id.edition_annee, StringUtils.nonZero(this.currentEdition.getAnnee()));
        setUIElement(this.view, R.id.edition_stock, this.currentEdition.isStock());
        setUIElement(this.view, R.id.edition_couleur, this.currentEdition.isCouleur());
        setUIElement(this.view, R.id.edition_dedicace, this.currentEdition.isDedicace());
        setUIElement(this.view, R.id.edition_offert, this.currentEdition.isOffert());

        setUIElement(this.view, R.id.edition_typeedition, this.currentEdition.getTypeEdition(), R.id.fiche_edition_row_typeedition);
        setUIElement(this.view, R.id.edition_reliure, this.currentEdition.getReliure(), R.id.fiche_edition_row_reliure);
        setUIElement(this.view, R.id.edition_etatedition, this.currentEdition.getEtat(), R.id.fiche_edition_row_etatedition);
        setUIElement(this.view, R.id.edition_orientation, this.currentEdition.getOrientation(), R.id.fiche_edition_row_orientation);
        setUIElement(this.view, R.id.edition_formatedition, this.currentEdition.getFormatEdition(), R.id.fiche_edition_row_formatedition);
        setUIElement(this.view, R.id.edition_senslecture, this.currentEdition.getSensLecture(), R.id.fiche_edition_row_senslecture);

        if (this.currentEdition.isGratuit())
            setUIElement(this.view, R.id.edition_prix, getResources().getString(R.string.gratuit));
        else {
            final Double prix = this.currentEdition.getPrix();
            if ((prix == null) || prix.equals(0.0))
                setUIElement(this.view, R.id.edition_prix, "");
            else
                setUIElement(this.view, R.id.edition_prix, UserConfig.getInstance().getFormatMonetaire().format(prix));
        }

        final Double prixCote = this.currentEdition.getPrixCote();
        if ((prixCote != null) && (prixCote > 0))
            setUIElement(this.view, R.id.edition_cote, String.format("%s (%d)", UserConfig.getInstance().getFormatMonetaire().format(prixCote), this.currentEdition.getAnneeCote()));
        else
            this.view.findViewById(R.id.fiche_edition_row_cote).setVisibility(View.GONE);
        {
            if (this.currentEdition.isOffert()) {
                setUIElement(this.view, R.id.label_edition_aquisition, getResources().getString(R.string.fiche_edition_offertle));
            } else
                setUIElement(this.view, R.id.label_edition_aquisition, getResources().getString(R.string.fiche_edition_achetele));
        }
        final Date dateAquisition = this.currentEdition.getDateAquisition();
        if (dateAquisition != null)
            setUIElement(this.view, R.id.edition_aquisition, DateFormat.getDateFormat(getActivity()).format(dateAquisition));
        else
            this.view.findViewById(R.id.fiche_edition_row_aquisition).setVisibility(View.GONE);
        setUIElement(this.view, R.id.edition_notes, this.currentEdition.getNotes(), R.id.fiche_edition_row_notes);
        setUIElement(this.view, R.id.edition_numero, this.currentEdition.getNumeroPerso(), R.id.fiche_edition_row_numero);
        setUIElement(this.view, R.id.edition_pages, StringUtils.nonZero(this.currentEdition.getPages()), R.id.fiche_edition_row_pages);

/*
      ShowCouverture(0);
*/
    }
}
