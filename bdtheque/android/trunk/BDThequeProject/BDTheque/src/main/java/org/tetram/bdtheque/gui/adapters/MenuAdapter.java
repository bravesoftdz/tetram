package org.tetram.bdtheque.gui.adapters;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;

import java.util.List;

@SuppressWarnings("UnusedDeclaration")
public class MenuAdapter extends ArrayAdapter<MenuEntry> {

    public MenuAdapter(Context context, int resource, List<MenuEntry> objects) {
        super(context, resource, objects);
    }

    public MenuAdapter(Context context, int resource, int textViewResourceId, List<MenuEntry> objects) {
        super(context, resource, textViewResourceId, objects);
    }

    @Override
    public long getItemId(int position) {
        return super.getItem(position).getId();
    }

    @Nullable
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = super.getView(position, convertView, parent);
        if (view instanceof TextView) {
            ((TextView) view).setCompoundDrawablesWithIntrinsicBounds(super.getItem(position).getDrawableId(), 0, 0, 0);
        } else {
            View image = view.findViewById(android.R.id.icon);
            if (image instanceof ImageView)
                ((ImageView) image).setImageResource(super.getItem(position).getDrawableId());
        }
        return view;
    }
}
