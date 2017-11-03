package org.tetram.bdtheque.data.orm;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.annotations.Filters;
import org.tetram.bdtheque.data.orm.annotations.OneToMany;
import org.tetram.bdtheque.data.orm.annotations.OrderBy;

@SuppressWarnings("UnusedDeclaration")
public class MultiplePropertyDescriptor extends PropertyDescriptor {
    OneToMany annotation;
    Class<? extends CommonBean> beanClass;
    OrderBy orderBy;
    Filters filters;

    public Class<? extends CommonBean> getBeanClass() {
        return this.beanClass;
    }

    public OneToMany getAnnotation() {

        return this.annotation;
    }

    public Filters getFilters() {
        return this.filters;
    }

    public OrderBy getOrderBy() {
        return this.orderBy;
    }

}
