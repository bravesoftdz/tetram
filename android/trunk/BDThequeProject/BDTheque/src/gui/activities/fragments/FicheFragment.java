package org.tetram.bdtheque.gui.activities.fragments;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ScrollView;
import android.widget.Toast;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;

import java.lang.reflect.InvocationTargetException;
import java.util.UUID;

public abstract class FicheFragment extends Fragment {

    @Nullable
    public static FicheFragment newInstance(Class<? extends FicheFragment> classFiche, CommonBean bean) {
        FicheFragment ficheFragment = null;
        try {
            ficheFragment = classFiche.getConstructor().newInstance();
        } catch (java.lang.InstantiationException | IllegalAccessException e) {
            e.printStackTrace();
            return null;
        } catch (NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }

        Bundle args = new Bundle();
        args.putParcelable("bean", bean);
        ficheFragment.setArguments(args);

        return ficheFragment;
    }

    public UUID getShownId() {
        return ((CommonBean) getArguments().getParcelable("bean")).getId();
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
        } else {
            ScrollView view = new ScrollView(getActivity());
            buildView(inflater, view, savedInstanceState);
            return view;
        }

    }

    @Nullable
    public View buildView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        CommonBean bean = getArguments().getParcelable("bean");

        Toast.makeText(this.getActivity(), String.format("%s: %s", bean.getClass().getSimpleName(), bean.getId().toString()), Toast.LENGTH_LONG).show();

        return null;
    }

}
