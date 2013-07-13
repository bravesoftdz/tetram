package org.tetram.bdtheque.gui.activities.fragments;

import android.os.Bundle;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.utils.StringUtils;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

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
        listEditions.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getEditions()));
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
        setUIElement(this.view, R.id.edition_isbn, StringUtils.formatISBN(this.currentEdition.getISBN()));

        final EditeurBean editeur = this.currentEdition.getEditeur();
        String nomEditeur = StringUtils.formatTitre(editeur.getNom());
        if (editeur.getSiteWeb() != null) {
            nomEditeur = String.format("<a href=\"%s\">%s</a>", editeur.getSiteWeb(), nomEditeur);
            final TextView textView = (TextView) this.view.findViewById(R.id.edition_editeur);
            textView.setMovementMethod(LinkMovementMethod.getInstance());
            textView.setText(Html.fromHtml(nomEditeur));
        } else {
            setUIElement(this.view, R.id.edition_editeur, nomEditeur);
        }

        final CollectionLiteBean collection = this.currentEdition.getCollection();
        if (collection == null)
            this.view.findViewById(R.id.fiche_edition_row_collection).setVisibility(View.GONE);
        else
            setUIElement(this.view, R.id.edition_collection, StringUtils.formatTitre(collection.getNom()));
    }
}
