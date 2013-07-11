package org.tetram.bdtheque.gui.components;

import android.content.Context;
import android.database.DataSetObserver;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Adapter;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class LinearListView extends LinearLayout {
    private Adapter adapter;
    private final Observer observer = new Observer(this);

    public LinearListView(Context context) {
        super(context);
    }

    public LinearListView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public LinearListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public void setAdapter(Adapter adapter) {
        if (this.adapter != null)
            this.adapter.unregisterDataSetObserver(this.observer);

        this.adapter = adapter;
        adapter.registerDataSetObserver(this.observer);
        this.observer.onChanged();
    }

    private static class Observer extends DataSetObserver {
        LinearListView context;

        public Observer(LinearListView context) {
            super();
            this.context = context;
        }

        @Override
        public void onChanged() {
            List<View> oldViews = new ArrayList<>(this.context.getChildCount());

            for (int i = 0; i < this.context.getChildCount(); i++)
                oldViews.add(this.context.getChildAt(i));

            Iterator<View> iter = oldViews.iterator();

            this.context.removeAllViews();

            for (int i = 0; i < this.context.adapter.getCount(); i++) {
                View convertView = iter.hasNext() ? iter.next() : null;
                this.context.addView(this.context.adapter.getView(i, convertView, this.context));
            }
            super.onChanged();
        }

        @Override
        public void onInvalidated() {
            this.context.removeAllViews();
            super.onInvalidated();
        }
    }
}
