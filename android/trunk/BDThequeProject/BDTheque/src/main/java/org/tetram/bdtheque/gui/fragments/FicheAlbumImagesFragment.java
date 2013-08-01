package org.tetram.bdtheque.gui.fragments;

import android.os.Bundle;
import android.text.format.DateFormat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.Toast;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.EditeurBean;
import org.tetram.bdtheque.data.bean.EditionBean;
import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.UserConfig;

import java.util.Date;

import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElement;
import static org.tetram.bdtheque.gui.utils.UIUtils.setUIElementURL;

public class FicheAlbumImagesFragment extends FicheFragment {

    @SuppressWarnings("FieldCanBeLocal")
    private EditionBean currentEdition;
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
        listEditions.setSelection(0);
        loadEdition((EditionBean) listEditions.getAdapter().getItem(0));

        this.view.findViewById(R.id.edition_btn_next).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity(), getActivity().getExternalFilesDir(null).toString(), Toast.LENGTH_LONG).show();
            }
        });

        return this.view;
    }

    private void loadEdition(EditionBean edition) {
        this.currentEdition = edition;
/*
      ShowCouverture(0);
*/
    }
}
