package org.tetram.bdtheque.gui.adapters;

import android.content.Context;
import android.util.SparseArray;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.RatingBar;
import android.widget.SectionIndexer;
import android.widget.TextView;

import org.tetram.bdtheque.R;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;
import org.tetram.bdtheque.data.bean.enums.Notation;
import org.tetram.bdtheque.data.dao.InitialeRepertoireDao;
import org.tetram.bdtheque.utils.StringUtils;
import org.tetram.bdtheque.utils.UserConfig;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@SuppressWarnings("unchecked")
public class RepertoireAdapter<T extends TreeNodeBean> extends BaseExpandableListAdapter implements SectionIndexer, AbsListView.OnScrollListener {

    private final ExpandableListView expandableListView;
    @SuppressWarnings("UnusedDeclaration")
    private final LinkedHashMap<Character, Integer> sectionsPositions = new LinkedHashMap<>();
    @SuppressWarnings("UnusedDeclaration")
    private final List<Character> sections = new ArrayList<>();
    private final List<Character> realListInitiales = new ArrayList<>();
    InitialeRepertoireDao repertoireDao;
    Context context;
    private List<? extends InitialeBean> listInitiales;
    private SparseArray<List<T>> mapData;
    private boolean manualScroll;

    public RepertoireAdapter(final Context context, final InitialeRepertoireDao dao, ExpandableListView expandableListView) {
        super();
        this.context = context;
        this.repertoireDao = dao;
        this.expandableListView = expandableListView;
        this.expandableListView.setOnScrollListener(this);
    }

    public void setRepertoireDao(InitialeRepertoireDao repertoireDao) {
        this.repertoireDao = repertoireDao;
        this.listInitiales = null;
        this.mapData = null;
        this.notifyDataSetChanged();
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        this.manualScroll = scrollState == SCROLL_STATE_TOUCH_SCROLL;
    }

    private void ensureInitiales() {
        if (this.listInitiales == null) {
            this.listInitiales = this.repertoireDao.getInitiales();
/*
            InitialeBean initialeBean;
            Character c, prevC = null;
            for (int i = 0; i < this.listInitiales.size(); i++) {
                initialeBean = this.listInitiales.get(i);
                c = Character.toUpperCase(initialeBean.getLabel().charAt(0));
                if (!c.equals(prevC)) {
                    this.sectionsPositions.put(c, i);
                    prevC = c;
                }
            }
            this.sections.addAll(this.sectionsPositions.keySet());
*/
            this.realListInitiales.clear();
            for (final InitialeBean initiale : this.listInitiales)
                this.realListInitiales.add(Character.toUpperCase(initiale.getRawLabel().charAt(0)));
        }
    }

    private void ensureData(final Integer initiale) {
        if (this.mapData == null)
            this.mapData = new SparseArray<>(getGroupCount());

        if (this.mapData.indexOfKey(initiale) < 0)
            this.mapData.put(initiale, this.repertoireDao.getData(this.listInitiales.get(initiale)));
    }

    @Override
    public int getGroupCount() {
        if (this.repertoireDao == null) return 0;

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

        GroupViewHolder holder;

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inf.inflate(R.layout.treenode_initiale, null);

            holder = new GroupViewHolder();
            holder.textValue = (TextView) view.findViewById(R.id.text_value);
            holder.textCount = (TextView) view.findViewById(R.id.text_count);

            view.setTag(holder);
        } else {
            holder = (GroupViewHolder) view.getTag();
        }

        holder.textValue.setText(initiale.getLabel());
        holder.textCount.setText(StringUtils.ajoutString("", StringUtils.nonZero(initiale.getCount()), " ", "(", ")"));

        return view;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        ensureData(groupPosition);
        TreeNodeBean bean = this.mapData.get(groupPosition).get(childPosition);

        ItemViewHolder holder;

        View view = convertView;
        if (view == null) {
            LayoutInflater inf = (LayoutInflater) this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inf.inflate(R.layout.treenode_bean, null);

            holder = new ItemViewHolder();
            holder.text = (TextView) view.findViewById(R.id.textView);
            holder.ratingBar = (RatingBar) view.findViewById(R.id.ratingBar);

            view.setTag(holder);
        } else {
            holder = (ItemViewHolder) view.getTag();
        }

        holder.text.setText(bean.getTreeNodeText());
        holder.ratingBar.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return true;
            }
        });
        if (UserConfig.getInstance().shouldAfficheNoteListes() && ((bean.getTreeNodeRating().compareTo(Notation.PAS_NOTE)) > 0)) {
            holder.ratingBar.setRating(bean.getTreeNodeRating().getValue() - 1);
            holder.ratingBar.setVisibility(View.VISIBLE);
        } else
            holder.ratingBar.setVisibility(View.GONE);

        return view;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }

    @Override
    public Object[] getSections() {
        if (this.repertoireDao == null) return new Object[0];

        ensureInitiales();
//        return this.sections.toArray();
//        return this.listInitiales.toArray();
        return this.realListInitiales.toArray();
    }

    @SuppressWarnings("SuspiciousMethodCalls")
    @Override
    public int getPositionForSection(int sectionIndex) {
        if (this.manualScroll) {
/*
            int flatSection = ExpandableListView.getPackedPositionGroup(this.expandableListView.getExpandableListPosition(section));
            Log.i(this.getClass().getName(), String.valueOf(section) + " - " + String.valueOf(flatSection));
            Character character = this.sections.get(flatSection);
            return this.sectionsPositions.get(character);
*/
            return sectionIndex;
        } else {
            return this.expandableListView.getFlatListPosition(ExpandableListView.getPackedPositionForGroup(sectionIndex));
        }
    }

    @Override
    public int getSectionForPosition(int position) {
        return ExpandableListView.getPackedPositionGroup(this.expandableListView.getExpandableListPosition(position));
    }

    private static class GroupViewHolder {
        TextView textValue, textCount;
    }

    private static class ItemViewHolder {
        TextView text;
        RatingBar ratingBar;
    }
}
