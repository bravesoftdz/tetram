package org.tetram.bdtheque.gui.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.RatingBar;
import android.widget.TextView;
import org.tetram.bdtheque.R;
import org.tetram.bdtheque.UserConfig;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RepertoireAdapter<T extends TreeNodeBean> extends BaseExpandableListAdapter {

    private List<InitialeBean> listInitiales;
    private Map<Integer, List<T>> mapData;
    InitialeRepertoireDao dao;
    Context context;

    public RepertoireAdapter(Context context, InitialeRepertoireDao dao) {
        this.context = context;
        this.dao = dao;
    }

    private void ensureInitiales() {
        if (listInitiales == null)
            listInitiales = dao.getInitiales();
    }

    private void ensureData(Integer initiale) {
        if (mapData == null)
            mapData = new HashMap<Integer, List<T>>(getGroupCount());

        if (!mapData.containsKey(initiale))
            mapData.put(initiale, dao.getData(listInitiales.get(initiale)));
    }

    @Override
    public int getGroupCount() {
        ensureInitiales();
        return listInitiales.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        ensureData(groupPosition);
        return mapData.get(groupPosition).size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listInitiales.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        ensureData(groupPosition);
        return mapData.get(groupPosition).get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        ensureInitiales();
        InitialeBean initiale = listInitiales.get(groupPosition);
        return initiale.getValue().hashCode();
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        ensureInitiales();
        InitialeBean initiale = listInitiales.get(groupPosition);
        ensureData(groupPosition);
        return (initiale.getValue() + mapData.get(groupPosition).get(childPosition).getId()).hashCode();
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        ensureInitiales();
        InitialeBean initiale = listInitiales.get(groupPosition);

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
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
        TreeNodeBean bean = mapData.get(groupPosition).get(childPosition);

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inf.inflate(R.layout.treenode_bean, null);
        }

        TextView textView = (TextView) view.findViewById(R.id.textView);
        textView.setText(bean.getTreeNodeText());
        RatingBar ratingBar = (RatingBar) view.findViewById(R.id.ratingBar);
        ratingBar.setOnTouchListener(new View.OnTouchListener() {
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });
        if (UserConfig.getInstance().getAfficheNoteListes() && bean.getTreeNodeRating() != null) {
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
