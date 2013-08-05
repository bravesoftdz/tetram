package org.tetram.bdtheque.data.orm;

import org.tetram.bdtheque.data.bean.abstracts.CommonBean;

import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("UnusedDeclaration")
public class SQLDescriptor {
    Class<? extends CommonBean> beanClass;
    String tableName;
    SimplePropertyDescriptor primaryKey;
    Map<SimplePropertyDescriptor, SQLDescriptor> columns = new HashMap<SimplePropertyDescriptor, SQLDescriptor>();

    public Class<? extends CommonBean> getBeanClass() {
        return this.beanClass;
    }

    public String getTableName() {
        return this.tableName;
    }

    public SimplePropertyDescriptor getPrimaryKey() {
        return this.primaryKey;
    }

    public Map<SimplePropertyDescriptor, SQLDescriptor> getColumns() {
        return this.columns;
    }
}
