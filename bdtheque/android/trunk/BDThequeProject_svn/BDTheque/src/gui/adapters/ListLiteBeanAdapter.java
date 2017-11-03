package org.tetram.bdtheque.gui.adapters;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.TreeNodeBean;

import java.util.List;

public class ListLiteBeanAdapter<T extends TreeNodeBean> extends ArrayAdapter<T> {

    public ListLiteBeanAdapter(Context context, int resource, List<T> objects) {
        super(context, resource, objects);
    }

    @Nullable
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        TextView view = (TextView) super.getView(position, convertView, parent);
        T item = getItem(position);
        view.setText(item.getTreeNodeText());
        view.setLayoutParams(new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return view;
    }
}
