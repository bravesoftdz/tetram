package org.tetram.bdtheque.gui.activities.fragments;

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
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.gui.components.LinearListView;
import org.tetram.bdtheque.gui.utils.UIUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

@SuppressWarnings("UnusedDeclaration")
public class FicheAlbumFragment extends FicheFragment {

    @SuppressWarnings("MagicConstant")
    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        CommonBean bean = getArguments().getParcelable("bean");
        AlbumDao dao = new AlbumDao(getActivity());
        AlbumBean album = dao.getById(bean.getId());

        if (album == null) return null;
        final SerieBean serie = album.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_fragment, container, false);
        if (serie != null) {
            String titreSerie = StringUtils.formatTitre(serie.getTitre());
            if (serie.getSiteWeb() != null) {
                titreSerie = String.format("<a href=\"%s\">%s</a>", serie.getSiteWeb(), titreSerie);
                final TextView textView = (TextView) v.findViewById(R.id.album_serie);
                textView.setMovementMethod(LinkMovementMethod.getInstance());
                textView.setText(Html.fromHtml(titreSerie));
            } else {
                UIUtils.setUIElement(v, R.id.album_serie, titreSerie);
            }
            UIUtils.setUIElement(v, R.id.album_genres, serie.getGenreList());
        }
        UIUtils.setUIElement(v, R.id.album_titre, StringUtils.formatTitre(album.getTitre()));
        UIUtils.setUIElement(v, R.id.album_tome, StringUtils.nonZero(album.getTome()));
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
            UIUtils.setUIElement(v, R.id.album_parution, DateFormat.format(parutionFormat, dateParution));
        }
        UIUtils.setUIElement(v, R.id.album_integrale, album.isIntegrale());
        if (album.isIntegrale()) {
            ((CheckBox) v.findViewById(R.id.album_integrale)).setText(
                    StringUtils.ajoutString(
                            BDThequeApplication.getInstance().getString(R.string.fiche_album_integrale),
                            StringUtils.ajoutString(StringUtils.nonZero(album.getTomeDebut()), StringUtils.nonZero(album.getTomeFin()), " à "),
                            " ", "[", "]")
            );
        }

        LinearListView listView;

        listView = (LinearListView) v.findViewById(R.id.album_scenaristes);
        listView.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getScenaristes()));
        //listView.setMinimumHeight(Math.min(album.getScenaristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        listView = (LinearListView) v.findViewById(R.id.album_dessinateurs);
        listView.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getDessinateurs()));
        //listView.setMinimumHeight(Math.min(album.getDessinateurs().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        listView = (LinearListView) v.findViewById(R.id.album_coloristes);
        listView.setAdapter(new ArrayAdapter<>(getActivity(), android.R.layout.simple_list_item_1, album.getColoristes()));
        //listView.setMinimumHeight(Math.min(album.getColoristes().size(), 3) * android.R.attr.listPreferredItemHeightSmall);

        UIUtils.setUIElement(v, R.id.album_horsserie, album.isHorsSerie());
        String sujet = album.getSujet();
        if ((serie != null) && ((sujet == null) || "".equals(sujet)))
            sujet = serie.getSujet();
        UIUtils.setUIElement(v, R.id.album_histoire, sujet);
        String notes = album.getNotes();
        if ((serie != null) && ((notes == null) || "".equals(notes)))
            notes = serie.getNotes();
        UIUtils.setUIElement(v, R.id.album_notes, notes);

        return v;
    }
}
