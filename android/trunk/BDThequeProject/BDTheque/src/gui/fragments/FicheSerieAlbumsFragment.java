package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.SerieBean;
import org.tetram.bdtheque.gui.adapters.ListLiteBeanAdapter;

public class FicheSerieAlbumsFragment extends FicheFragment {

    @SuppressWarnings("VariableNotUsedInsideIf")
    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        CommonBean bean = getArguments().getParcelable("bean");
        SerieBean serie;
        AlbumBean album;
        if (bean instanceof AlbumBean) {
            album = (AlbumBean) bean;
            serie = album.getSerie();
        } else {
            album = null;
            serie = (SerieBean) bean;
        }

        View v = inflater.inflate(R.layout.fiche_serie_albums_fragment, container, false);
        if (serie != null) {
            final ListView listAlbums = (ListView) v.findViewById(R.id.album_albums);
            final int itemLayout = (album == null) ? android.R.layout.simple_list_item_1 : R.layout.simple_list_item_single_choice;
            listAlbums.setAdapter(new ListLiteBeanAdapter<>(getActivity(), itemLayout, serie.getAlbums()));
            listAlbums.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    showFiche((CommonBean) parent.getAdapter().getItem(position));
                }
            });
            if (album != null)
                for (int i = 0; i < serie.getAlbums().size(); i++)
                    if (album.getId().equals(serie.getAlbums().get(i).getId()))
                        listAlbums.setItemChecked(i, true);
        }

        return v;
    }
}
