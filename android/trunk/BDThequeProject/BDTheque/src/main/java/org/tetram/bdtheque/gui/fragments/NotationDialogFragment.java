package org.tetram.bdtheque.gui.fragments;

import android.app.AlertDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.gui.adapters.MenuAdapter;
import org.tetram.bdtheque.gui.adapters.MenuEntry;

import java.util.ArrayList;
import java.util.List;

public class NotationDialogFragment extends DialogFragment {

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // int title = getArguments().getInt("title");

        final AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        //.setIcon(R.drawable.alert_dialog_icon)
        //.setTitle(title)
        LayoutInflater inflater = getActivity().getLayoutInflater();
        final ListView listView = (ListView) inflater.inflate(R.layout.dialog_notation, null);

        List<MenuEntry> menuEntries = new ArrayList<MenuEntry>();
        for (Notation notation : Notation.values())
            menuEntries.add(notation.getMenuEntry(getActivity()));

        MenuAdapter mSpinnerAdapter = new MenuAdapter(getActivity(), android.R.layout.simple_spinner_dropdown_item, menuEntries);
        listView.setAdapter(mSpinnerAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

                dismiss();
            }
        });

        builder.setView(listView);
        return builder.create();
    }
}