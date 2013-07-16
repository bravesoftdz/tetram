package org.tetram.bdtheque.gui.adapters;

import android.content.Context;
import android.widget.ArrayAdapter;

import java.util.List;

public class MenuAdapter extends ArrayAdapter<MenuEntry> {

    public MenuAdapter(Context context, int textViewResourceId, List<MenuEntry> objects) {
        super(context, textViewResourceId, objects);
    }

    @Override
    public long getItemId(int position) {
        return super.getItem(position).getId();
    }
}
