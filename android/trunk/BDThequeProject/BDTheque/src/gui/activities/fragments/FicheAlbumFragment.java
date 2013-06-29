package org.tetram.bdtheque.gui.activities.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.AlbumDao;
import org.tetram.bdtheque.gui.utils.UIUtils;
import org.tetram.bdtheque.utils.StringUtils;

@SuppressWarnings("UnusedDeclaration")
public class FicheAlbumFragment extends FicheFragment {

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        CommonBean bean = getArguments().getParcelable("bean");
        AlbumDao dao = new AlbumDao(getActivity());
        AlbumBean album = dao.getById(bean.getId());

        if (album == null) return null;

        View v = inflater.inflate(R.layout.fiche_album_fragment, container);
        UIUtils.setUIElement(v, R.id.album_titre, StringUtils.formatTitre(album.getTitre()));

        return v;
    }
}
