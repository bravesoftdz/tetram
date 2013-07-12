package org.tetram.bdtheque.gui.activities.fragments;

import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TabHost;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.AlbumBean;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.AlbumDao;

public class FicheAlbumFragment extends FicheFragment {

    private static final String TAB_DETAILS = "détails";
    private static final String TAB_EDITIONS = "éditions";

    @Nullable
    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);

        CommonBean bean = getArguments().getParcelable("bean");
        AlbumDao dao = new AlbumDao(getActivity());
        AlbumBean album = dao.getById(bean.getId());

        View v = inflater.inflate(R.layout.fiche_album_fragment, container, false);

        TabHost tabHost = (TabHost) v.findViewById(android.R.id.tabhost);
        tabHost.setup();

        if (album.getEditions().isEmpty())
            v.findViewById(android.R.id.tabs).setVisibility(View.GONE);

        TabHost.TabSpec spec;

        spec = tabHost.newTabSpec(TAB_DETAILS);
        spec.setIndicator(TAB_DETAILS);
        spec.setContent(R.id.tab_album_detail);
        tabHost.addTab(spec);

        spec = tabHost.newTabSpec(TAB_EDITIONS);
        spec.setIndicator(TAB_EDITIONS);
        spec.setContent(R.id.tab_album_editions);
        tabHost.addTab(spec);

        FicheAlbumDetailFragment detailFragment = (FicheAlbumDetailFragment) FicheFragment.newInstance(FicheAlbumDetailFragment.class, album);
        FicheAlbumEditionsFragment editionsFragment = (FicheAlbumEditionsFragment) FicheFragment.newInstance(FicheAlbumEditionsFragment.class, album);

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
        fragmentTransaction.replace(R.id.tab_album_detail, detailFragment);
        fragmentTransaction.replace(R.id.tab_album_editions, editionsFragment);
        fragmentTransaction.commit();

        return v;
    }

/*
    private View createTabView(final String text, final int id) {
        View view = LayoutInflater.from(this).inflate(R.layout.tabs_icon, null);
        ImageView imageView = (ImageView) view.findViewById(R.id.tab_icon);
        imageView.setImageDrawable(getResources().getDrawable(id));
        ((TextView) view.findViewById(R.id.tab_text)).setText(text);
        return view;
    }
*/
}
