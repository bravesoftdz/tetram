package org.tetram.bdtheque.data.orm;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.annotations.OneToMany;

@SuppressWarnings("UnusedDeclaration")
public class MultiplePropertyDescriptor extends PropertyDescriptor {
    OneToMany annotation;
    Class<? extends CommonBean> subBeanType;

    public OneToMany getAnnotation() {

        return this.annotation;
    }

    public Class<? extends CommonBean> getSubBeanType() {
        return this.subBeanType;
    }

}
