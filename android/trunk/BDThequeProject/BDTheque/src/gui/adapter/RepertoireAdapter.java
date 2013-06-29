package org.tetram.bdtheque.gui.adapter;

import android.content.Context;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.RatingBar;
import android.widget.TextView;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.UserConfig;

import java.util.List;

@SuppressWarnings("unchecked")
public class RepertoireAdapter<T extends TreeNodeBean> extends BaseExpandableListAdapter {

    private List<? extends InitialeBean> listInitiales;
    private SparseArray<List<T>> mapData;
    InitialeRepertoireDao repertoireDao;
    Context context;

    public RepertoireAdapter(final Context context, final InitialeRepertoireDao dao) {
        super();
        this.context = context;
        this.repertoireDao = dao;
    }

    private void ensureInitiales() {
        if (this.listInitiales == null)
            this.listInitiales = this.repertoireDao.getInitiales();
    }

    private void ensureData(final Integer initiale) {
        if (this.mapData == null)
            this.mapData = new SparseArray<>(getGroupCount());

        if (this.mapData.indexOfKey(initiale) < 0)
            this.mapData.put(initiale, this.repertoireDao.getData(this.listInitiales.get(initiale)));
    }

    @Override
    public int getGroupCount() {
        ensureInitiales();
        return this.listInitiales.size();
    }

    @Override
    public int getChildrenCount(final int groupPosition) {
        ensureData(groupPosition);
        return this.mapData.get(groupPosition).size();
    }

    @Override
    public Object getGroup(final int groupPosition) {
        return this.listInitiales.get(groupPosition);
    }

    @Override
    public Object getChild(final int groupPosition, final int childPosition) {
        ensureData(groupPosition);
        return this.mapData.get(groupPosition).get(childPosition);
    }

    @Override
    public long getGroupId(final int groupPosition) {
        ensureInitiales();
        final InitialeBean initiale = this.listInitiales.get(groupPosition);
        return initiale.hashCode();
    }

    @Override
    public long getChildId(final int groupPosition, final int childPosition) {
        ensureInitiales();
        InitialeBean initiale = this.listInitiales.get(groupPosition);
        ensureData(groupPosition);
        return initiale.hashCode() + this.mapData.get(groupPosition).get(childPosition).getId().hashCode();
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        ensureInitiales();
        InitialeBean initiale = this.listInitiales.get(groupPosition);

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inf.inflate(R.layout.treenode_initiale, null);
        }

        TextView textView;
        textView = (TextView) view.findViewById(R.id.text_value);
        textView.setText(initiale.getLabel());
        textView = (TextView) view.findViewById(R.id.text_count);
        textView.setText(StringUtils.ajoutString("", StringUtils.nonZero(initiale.getCount()), " ", "(", ")"));

        return view;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        ensureData(groupPosition);
        TreeNodeBean bean = this.mapData.get(groupPosition).get(childPosition);

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inf.inflate(R.layout.treenode_bean, null);
        }

        TextView textView = (TextView) view.findViewById(R.id.textView);
        textView.setText(bean.getTreeNodeText());
        RatingBar ratingBar = (RatingBar) view.findViewById(R.id.ratingBar);
        ratingBar.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });
        if (UserConfig.getInstance().shouldAfficheNoteListes() && (bean.getTreeNodeRating() != null)) {
            ratingBar.setRating(bean.getTreeNodeRating() - 1);
            ratingBar.setVisibility(View.VISIBLE);
        } else
            ratingBar.setVisibility(View.GONE);

        return view;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }

}
