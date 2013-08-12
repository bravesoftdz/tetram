package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
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

public class FicheAlbumImagesFragment extends FicheFragment {

    public static final String IMAGE_FRAGMENT_TAG = "org.tetram.bdtheque.gui.fragments.FicheAlbumImagesFragment.imageFragment";
    public static final String CURRENT_EDITION = "org.tetram.bdtheque.gui.fragments.FicheAlbumImagesFragment.currentEdition";

    private int currentEditionPosition;
    private Bundle lastImageFragmentState;

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        AlbumBean album = getArguments().getParcelable(FicheFragment.BEAN);
        if (album == null) return null;

        View v = inflater.inflate(R.layout.fiche_album_images_fragment, container, false);

        Spinner listEditions = (Spinner) v.findViewById(R.id.album_list_editions);
        if (album.getEditions().size() <= 1) listEditions.setVisibility(View.GONE);
        listEditions.setAdapter(new ArrayAdapter<EditionBean>(getActivity(), android.R.layout.simple_list_item_1, album.getEditions()));
        listEditions.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                FicheAlbumImagesFragment.this.currentEditionPosition = position;
                loadEdition((EditionBean) parent.getAdapter().getItem(position));
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });
        if ((savedInstanceState != null) && savedInstanceState.containsKey(CURRENT_EDITION))
            this.currentEditionPosition = savedInstanceState.getInt(CURRENT_EDITION, 0);
        else
            this.currentEditionPosition = 0;
        listEditions.setSelection(this.currentEditionPosition);
        loadEdition((EditionBean) listEditions.getAdapter().getItem(this.currentEditionPosition));

        if ((savedInstanceState != null) && savedInstanceState.containsKey(IMAGE_FRAGMENT_TAG))
            this.lastImageFragmentState =  savedInstanceState.getBundle(IMAGE_FRAGMENT_TAG);

        return v;
    }

    private void loadEdition(EditionBean edition) {
        getFragmentManager()
                .beginTransaction()
                .replace(R.id.edition_image, ImageFragment.getFragment(edition.getImages(), true, this.lastImageFragmentState), IMAGE_FRAGMENT_TAG)
                .commit();
        this.lastImageFragmentState = null;
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt(CURRENT_EDITION, this.currentEditionPosition);
        Fragment fragment = getFragmentManager().findFragmentByTag(IMAGE_FRAGMENT_TAG);
        if (fragment != null) {
            Bundle imageFragmentBundle = new Bundle();
            fragment.onSaveInstanceState(imageFragmentBundle);
            outState.putBundle("imageFragmentBundle", imageFragmentBundle);
        }
    }
}
