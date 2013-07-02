package org.tetram.bdtheque.gui.activities.fragments;

import android.os.Bundle;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.gui.utils.UIUtils;
import org.tetram.bdtheque.utils.StringUtils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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

        View v = inflater.inflate(R.layout.fiche_album_fragment, container);
        if (album.getSerie() != null) {
            String titreSerie = StringUtils.formatTitre(album.getSerie().getTitre());
            if (album.getSerie().getSiteWeb() != null) {
                titreSerie = String.format("<a href=\"%s\">%s</a>", album.getSerie().getSiteWeb(), titreSerie);
                final TextView textView = (TextView) v.findViewById(R.id.album_serie);
                textView.setMovementMethod(LinkMovementMethod.getInstance());
                textView.setText(Html.fromHtml(titreSerie));
            } else {
                UIUtils.setUIElement(v, R.id.album_serie, titreSerie);
            }
        }
        UIUtils.setUIElement(v, R.id.album_titre, StringUtils.formatTitre(album.getTitre()));
        UIUtils.setUIElement(v, R.id.album_tome, StringUtils.nonZero(album.getTome()));
        DateFormat parutionFormat;
        Date dateParution;
        if ((album.getAnneeParution() != null) && (album.getAnneeParution() > 0)) {
            final Calendar calendar = Calendar.getInstance();
            if ((album.getMoisParution() != null) && (album.getMoisParution() > 0)) {
                parutionFormat = new SimpleDateFormat("MMM yyyy");
                calendar.set(album.getAnneeParution(), album.getMoisParution() - 1, 1);
            } else {
                parutionFormat = new SimpleDateFormat("yyyy");
                calendar.set(album.getAnneeParution(), Calendar.JANUARY, 1);
            }
            UIUtils.setUIElement(v, R.id.album_parution, parutionFormat.format(calendar.getTime()));
        }
        UIUtils.setUIElement(v, R.id.album_integrale, album.isIntegrale());
        String s;
        if (album.isIntegrale()) {
            ((CheckBox) v.findViewById(R.id.album_integrale)).setText(
                    StringUtils.ajoutString(
                            BDThequeApplication.getInstance().getString(R.string.fiche_album_integrale),
                            StringUtils.ajoutString(StringUtils.nonZero(album.getTomeDebut()), StringUtils.nonZero(album.getTomeFin()), " à "),
                            " ", "[", "]")
            );
        }
        UIUtils.setUIElement(v, R.id.album_horsserie, album.isHorsSerie());
        UIUtils.setUIElement(v, R.id.album_histoire, album.getSujet());
        UIUtils.setUIElement(v, R.id.album_notes, album.getNotes());

        return v;
    }
}
