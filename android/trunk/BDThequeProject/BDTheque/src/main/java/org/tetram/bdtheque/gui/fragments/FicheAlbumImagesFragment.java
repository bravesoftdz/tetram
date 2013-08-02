package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditionBean;

import java.util.ArrayList;

public class FicheAlbumImagesFragment extends FicheFragment {

    @SuppressWarnings("FieldCanBeLocal")
    private EditionBean currentEdition;
    @SuppressWarnings("FieldCanBeLocal")
    private View view;

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable("bean");
        if (album == null) return null;

        this.view = inflater.inflate(R.layout.fiche_album_images_fragment, container, false);

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
        int position;
        if ((this.currentEdition != null) && album.getEditions().contains(this.currentEdition))
            position = album.getEditions().indexOf(this.currentEdition);
        else
            position = 0;
        listEditions.setSelection(position);
        loadEdition((EditionBean) listEditions.getAdapter().getItem(position));

        return this.view;
    }

    private void loadEdition(EditionBean edition) {
        this.currentEdition = edition;
        getFragmentManager().beginTransaction().replace(R.id.edition_image, ImageFragment.getFragment(this.currentEdition.getImages(), true)).commit();
    }

}
