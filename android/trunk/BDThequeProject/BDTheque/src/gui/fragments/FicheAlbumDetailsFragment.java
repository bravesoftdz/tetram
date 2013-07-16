package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.text.Html;
import android.text.format.DateFormat;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.gui.components.LinearListView;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;

@SuppressWarnings("UnusedDeclaration")
public class FicheAlbumDetailsFragment extends FicheFragment {

    @SuppressWarnings("MagicConstant")
    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable("bean");
        if (album == null) return null;
        final SerieBean serie = album.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_details_fragment, container, false);
        if (serie != null) {
            String titreSerie = StringUtils.formatTitre(serie.getTitre());
            if (serie.getSiteWeb() != null) {
                titreSerie = String.format("<a href=\"%s\">%s</a>", serie.getSiteWeb(), titreSerie);
                final TextView textView = (TextView) v.findViewById(R.id.album_serie);
                textView.setMovementMethod(LinkMovementMethod.getInstance());
                textView.setText(Html.fromHtml(titreSerie));
            } else {
                setUIElement(v, R.id.album_serie, titreSerie);
            }
            setUIElement(v, R.id.album_genres, serie.getGenreList(), R.id.fiche_album_row_genres);
        } else {
            v.findViewById(R.id.fiche_album_row_serie).setVisibility(View.GONE);
            v.findViewById(R.id.fiche_album_row_genres).setVisibility(View.GONE);
        }
        setUIElement(v, R.id.album_titre, StringUtils.formatTitre(album.getTitre()), R.id.fiche_album_row_titre);
        setUIElement(v, R.id.album_tome, StringUtils.nonZero(album.getTome()));
        String parutionFormat;
        Date dateParution;
        if ((album.getAnneeParution() != null) && (album.getAnneeParution() > 0)) {
            if ((album.getMoisParution() != null) && (album.getMoisParution() > 0)) {
                parutionFormat = "MMM yyyy";
                dateParution = new GregorianCalendar(album.getAnneeParution(), album.getMoisParution() - 1, 1).getTime();
            } else {
                parutionFormat = "yyyy";
                dateParution = new GregorianCalendar(album.getAnneeParution(), Calendar.JANUARY, 1).getTime();
            }
            setUIElement(v, R.id.album_parution, DateFormat.format(parutionFormat, dateParution));
        }
        setUIElement(v, R.id.album_integrale, album.isIntegrale());
        if (album.isIntegrale()) {
            ((CheckBox) v.findViewById(R.id.album_integrale)).setText(
                    StringUtils.ajoutString(
                            BDThequeApplication.getInstance().getString(R.string.fiche_album_integrale),
                            StringUtils.ajoutString(StringUtils.nonZero(album.getTomeDebut()), StringUtils.nonZero(album.getTomeFin()), " à "),
                            " ", "[", "]")
            );
        }

        LinearListView listAuteurs;

        if (album.getScenaristes().isEmpty())
            v.findViewById(R.id.fiche_album_row_scenaristes).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.album_scenaristes);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getScenaristes()));
        //listAuteurs.setMinimumHeight(Math.min(album.getScenaristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        if (album.getDessinateurs().isEmpty())
            v.findViewById(R.id.fiche_album_row_dessinateurs).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.album_dessinateurs);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getDessinateurs()));
        //listAuteurs.setMinimumHeight(Math.min(album.getDessinateurs().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        if (album.getColoristes().isEmpty())
            v.findViewById(R.id.fiche_album_row_coloristes).setVisibility(View.GONE);
        listAuteurs = (LinearListView) v.findViewById(R.id.album_coloristes);
        listAuteurs.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getColoristes()));
        //listAuteurs.setMinimumHeight(Math.min(album.getColoristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        setUIElement(v, R.id.album_horsserie, album.isHorsSerie());
        String sujet = album.getSujet();
        if ((serie != null) && ((sujet == null) || "".equals(sujet)))
            sujet = serie.getSujet();
        setUIElement(v, R.id.album_histoire, sujet, R.id.fiche_album_row_histoire);

        String notes = album.getNotes();
        if ((serie != null) && ((notes == null) || "".equals(notes)))
            notes = serie.getNotes();
        setUIElement(v, R.id.album_notes, notes, R.id.fiche_album_row_notes);

        return v;
    }
}
