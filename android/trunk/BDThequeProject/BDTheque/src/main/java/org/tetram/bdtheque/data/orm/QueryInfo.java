package org.tetram.bdtheque.data.orm;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("UnusedDeclaration")
public class QueryInfo {
    final List<String> tables = new ArrayList<String>();
    final List<String> fields = new ArrayList<String>();
    final LoadDescriptor loadDescriptor = new LoadDescriptor();
    final Map<String, String> sqlAliasMapping = new HashMap<String, String>();
    final Map<java.lang.reflect.Field, PropertySQLDescriptor> columns = new HashMap<java.lang.reflect.Field, PropertySQLDescriptor>();
    /**
     * utilisé uniquement en interne pour générer les alias
     */
    int indicator;
    Class<? extends CommonBean> beanClass;

    public Class<? extends CommonBean> getBeanClass() {
        return this.beanClass;
    }

    public List<String> getTables() {
        return this.tables;
    }

    public List<String> getFields() {
        return this.fields;
    }

    public LoadDescriptor getLoadDescriptor() {
        return this.loadDescriptor;
    }

    public Map<String, String> getSqlAliasMapping() {
        return this.sqlAliasMapping;
    }

    public Map<java.lang.reflect.Field, PropertySQLDescriptor> getColumns() {
        return this.columns;
    }

    public String getFullFieldname(String fieldName) {
        return getFullFieldname(this.beanClass, fieldName);
    }

    public String getFullFieldname(Class<? extends CommonBean> beanClass, String fieldName) {
        java.lang.reflect.Field fieldNomGenre = getPrivateField(beanClass, fieldName);
        PropertySQLDescriptor property = this.columns.get(fieldNomGenre);
        return property.getFullFieldName();
    }

    @Nullable
    private static <T extends CommonBean> java.lang.reflect.Field getPrivateField(Class<T> beanClass, String fieldName) {
        String[] fields = fieldName.split("\\.");

        java.lang.reflect.Field field = null;
        Class aClass = beanClass;

        for (String s : fields) {
            field = null;
            try {
                while ((aClass != null) && (field == null)) {
                    field = aClass.getDeclaredField(s);
                    aClass = aClass.getSuperclass();
                }
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            }

            if (field != null) {
                aClass = field.getType();
            } else
                return null;
        }
        return field;
    }

}
