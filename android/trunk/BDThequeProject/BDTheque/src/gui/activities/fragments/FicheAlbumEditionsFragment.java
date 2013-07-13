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
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.gui.utils.UIUtils;
import org.tetram.bdtheque.utils.StringUtils;

public class FicheAlbumEditionsFragment extends FicheFragment {

    @SuppressWarnings("FieldCanBeLocal")
    private EditionBean currentEdition;

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable("bean");
        if (album == null) return null;

        View v = inflater.inflate(R.layout.fiche_album_editions_fragment, container, false);

        Spinner listEditions = (Spinner) v.findViewById(R.id.album_list_editions);
        if (album.getEditions().size() <= 1) listEditions.setVisibility(View.GONE);
        listEditions.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getEditions()));
        listEditions.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                loadEdition((EditionBean) parent.getAdapter().getItem(position));
            }
        });
        listEditions.setSelection(0);

        return v;
    }

    private void loadEdition(EditionBean edition) {
        this.currentEdition = edition;
        View v = this.getView();
        UIUtils.setUIElement(v, R.id.edition_isbn, this.currentEdition.getISBN());

        String nomEditeur = StringUtils.formatTitre(this.currentEdition.getEditeur().getNom());
        if (this.currentEdition.getEditeur().getSiteWeb() != null) {
            nomEditeur = String.format("<a href=\"%s\">%s</a>", this.currentEdition.getEditeur().getSiteWeb(), nomEditeur);
            final TextView textView = (TextView) v.findViewById(R.id.edition_editeur);
            textView.setMovementMethod(LinkMovementMethod.getInstance());
            textView.setText(Html.fromHtml(nomEditeur));
        } else {
            UIUtils.setUIElement(v, R.id.edition_editeur, nomEditeur);
        }

    }
}
