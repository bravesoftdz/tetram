package org.tetram.bdtheque.gui.activities.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.tetram.bdtheque.R;

@SuppressWarnings("UnusedDeclaration")
public class FicheAlbumFragment extends FicheFragment {

    @Override
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.buildView(inflater, container, savedInstanceState);
        /*
        TextView text = new TextView(getActivity());
        int padding = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                4, getActivity().getResources().getDisplayMetrics());
        text.setPadding(padding, padding, padding, padding);
        text.setText(this.getClass().getCanonicalName());

        return text;
        */
        View v = inflater.inflate(R.layout.fiche_album_fragment, container);
        TextView text = (TextView) v.findViewById(R.id.test_field);
        text.setText(this.getClass().getCanonicalName());
        return v;
    }
}
