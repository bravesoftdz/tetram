package org.tetram.bdtheque.data.dao;

import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.bean.InitialeBean;
import org.tetram.bdtheque.data.bean.TreeNodeBean;

import java.util.List;

public interface InitialeRepertoireDao<B extends CommonBean & TreeNodeBean, I extends InitialeBean> {
    List<I> getInitiales();

    List<B> getData(I initiale);

    void setFiltre(String filtre);

    String getFiltre();
}
