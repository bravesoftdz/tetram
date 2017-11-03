package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;

@SuppressWarnings("UnusedDeclaration")
public interface CommonDao<T extends CommonBean> {
    T saveOrUpdate(T bean);
}
