package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;

import java.util.List;

@SuppressWarnings("UnusedDeclaration")
public interface CommonDao<T extends CommonBean> {
    List<T> getListFor(Class<? extends CommonBean> bean, String orderBy);

    T saveOrUpdate(T bean);
}
