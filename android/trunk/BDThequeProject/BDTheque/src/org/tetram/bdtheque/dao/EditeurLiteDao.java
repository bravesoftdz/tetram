package org.tetram.bdtheque.dao;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import org.tetram.bdtheque.bean.EditeurLiteBean;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.UUID;

/**
 * Created by Thierry on 02/06/13.
 */
public class EditeurLiteDao extends CommonDao<EditeurLiteBean> {

    public EditeurLiteDao(Context context) {
        super(context);
    }

    public EditeurLiteBean getEditeur(UUID albumId){
        return null;
    }

    public List<EditeurLiteBean> getEditeurs(){
        SQLiteDatabase rdb = getDb().getReadableDatabase();
        Cursor c = rdb.rawQuery("select * from editeurs", null);
        if (c.getCount() == 0) return null;

        List<EditeurLiteBean> result = new ArrayList<EditeurLiteBean>();

        while (!c.isAfterLast()){
            EditeurLiteBean e = new EditeurLiteBean();
            e.setId(UUID.fromString(c.getString(c.getColumnIndex("id_editeur"))));
            e.setNom(c.getString(c.getColumnIndex("nomediteur")));
            result.add(e);
        }
        return result;
    }
}
