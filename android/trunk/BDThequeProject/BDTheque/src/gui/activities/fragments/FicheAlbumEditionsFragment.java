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

        setUIElement(this.view, R.id.edition_année, StringUtils.nonZero(this.currentEdition.getAnnee()));
        setUIElement(this.view, R.id.edition_stock, this.currentEdition.isStock());
        setUIElement(this.view, R.id.edition_couleur, this.currentEdition.isCouleur());
        setUIElement(this.view, R.id.edition_dédicacé, this.currentEdition.isDedicace());
        setUIElement(this.view, R.id.edition_offert, this.currentEdition.isOffert());

/*
      TypeEdition.Caption := FCurrentEdition.TypeEdition.Caption;
      Reliure.Caption := FCurrentEdition.Reliure.Caption;
      Etat.Caption := FCurrentEdition.Etat.Caption;
      Pages.Caption := NonZero(IntToStr(FCurrentEdition.NombreDePages));
      lbOrientation.Caption := FCurrentEdition.Orientation.Caption;
      lbFormat.Caption := FCurrentEdition.FormatEdition.Caption;
      lbSensLecture.Caption := FCurrentEdition.SensLecture.Caption;
      lbNumeroPerso.Caption := FCurrentEdition.NumeroPerso;
*/
        if (this.currentEdition.isOffert())
            setUIElement(this.view, R.id.label_edition_aquisition, getResources().getString(R.string.fiche_edition_offertle));
        else
            setUIElement(this.view, R.id.label_edition_aquisition, getResources().getString(R.string.fiche_edition_achetéle));
/*
      AcheteLe.Caption := FCurrentEdition.sDateAchat;
      edNotes.Text := FCurrentEdition.Notes.Text;

      ShowCouverture(0);
      if FCurrentEdition.Gratuit then Prix.Caption := rsTransGratuit
      else if FCurrentEdition.Prix = 0 then Prix.Caption := ''
      else Prix.Caption := FormatCurr(FormatMonnaie, FCurrentEdition.Prix);

      if FCurrentEdition.PrixCote > 0 then
          lbCote.Caption := Format('%s (%d)', [FormatCurr(FormatMonnaie, FCurrentEdition.PrixCote), FCurrentEdition.AnneeCote])
      else lbCote.Caption := '';
*/
    }
}
