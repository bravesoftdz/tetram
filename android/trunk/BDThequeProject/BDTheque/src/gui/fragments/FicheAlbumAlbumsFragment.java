package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.gui.adapters.ListLiteBeanAdapter;

public class FicheAlbumAlbumsFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable("bean");
        if (album == null) return null;
        final SerieBean serie = album.getSerie();

        View v = inflater.inflate(R.layout.fiche_album_albums_fragment, container, false);
        if (serie != null) {
            final ListView listAlbums = (ListView) v.findViewById(R.id.album_albums);
            listAlbums.setAdapter(new ListLiteBeanAdapter<>(getActivity(), R.layout.simple_list_item_single_choice, serie.getAlbums()));
            listAlbums.setChoiceMode(AbsListView.CHOICE_MODE_SINGLE);
            for (int i = 0; i < serie.getAlbums().size(); i++)
                if (album.getId().equals(serie.getAlbums().get(i).getId()))
                    listAlbums.setItemChecked(i, true);
        }

        return v;
    }
}
