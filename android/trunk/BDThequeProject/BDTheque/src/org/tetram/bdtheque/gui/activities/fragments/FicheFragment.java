package org.tetram.bdtheque.gui.activities.fragments;

import android.app.Fragment;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ScrollView;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;

public class FicheFragment extends Fragment {
    /**
     * Create a new instance of FicheFragment, initialized to
     * show the text at 'index'.
     */
    public static FicheFragment newInstance(int index) {
        FicheFragment ficheFragment = new FicheFragment();

        // Supply index input as an argument.
        Bundle args = new Bundle();
        args.putInt("index", index);
        ficheFragment.setArguments(args);

        return ficheFragment;
    }

    public int getShownIndex() {
        return getArguments().getInt("index", 0);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (container == null) {
            // We have different layouts, and in one of them this
            // fragments's containing frame doesn't exist.  The fragments
            // may still be created from its saved state, but there is
            // no reason to try to create its view hierarchy because it
            // won't be displayed.  Note this is not needed -- we could
            // just run the code below, where we would create and return
            // the view hierarchy; it would just never be used.
            return null;
        } else
            return buildView(inflater, container, savedInstanceState);

    }

    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        ScrollView scroller = new ScrollView(getActivity());
        TextView text = new TextView(getActivity());
        int padding = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 4, getActivity().getResources().getDisplayMetrics());
        text.setPadding(padding, padding, padding, padding);
        scroller.addView(text);
        // text.setText(Shakespeare.DIALOGUE[getShownIndex()]);
        return scroller;
    }
}
