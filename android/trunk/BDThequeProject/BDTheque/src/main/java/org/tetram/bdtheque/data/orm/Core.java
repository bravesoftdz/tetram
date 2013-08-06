package org.tetram.bdtheque.data.orm;

import org.tetram.bdtheque.BDThequeApplication;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.factories.BeanFactory;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.data.orm.annotations.Field;
import org.tetram.bdtheque.data.orm.annotations.OneToMany;
import org.tetram.bdtheque.database.BDDatabaseHelper;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("UnusedDeclaration")
public abstract class Core {

    private static final Map<Class<? extends CommonBean>, List<PropertyDescriptor>> propertyDescriptorsList = new HashMap<Class<? extends CommonBean>, List<PropertyDescriptor>>();
    private static final Map<Class<? extends CommonBean>, SQLDescriptor> sqlDescriptorsList = new HashMap<Class<? extends CommonBean>, SQLDescriptor>();
    private static final Map<Class<? extends CommonBean>, QueryInfo> queryInfoList = new HashMap<Class<? extends CommonBean>, QueryInfo>();
    private static BDDatabaseHelper databaseHelper;

    private Core() {
        super();
    }

    public static BDDatabaseHelper getDatabaseHelper() {
        if (databaseHelper == null)
            databaseHelper = new BDDatabaseHelper(BDThequeApplication.getInstance());
        return databaseHelper;
    }

    public static String getSQLAlias(String sqlName, int indicator) {
        int aliasLength = SQLConstants.MAX_SQL_ALIAS_LENGTH - 1 - ((indicator == 0) ? 1 : ((int) Math.ceil(Math.log10(indicator)) + 1));
        return String.format("%s_%d", (sqlName.length() <= aliasLength) ? sqlName : sqlName.substring(0, aliasLength), indicator);
    }

    public static List<PropertyDescriptor> getPropertiesDescriptors(Class<? extends CommonBean> clasz) {
        return buildPropertiesDescriptors(clasz, clasz);
    }

    @SuppressWarnings({"unchecked", "VariableNotUsedInsideIf"})
    private static List<PropertyDescriptor> buildPropertiesDescriptors(Class<? extends CommonBean> masterClasz, Class<? extends CommonBean> clasz) {
        List<PropertyDescriptor> result = propertyDescriptorsList.get(clasz);
        if (null == result) {
            result = new ArrayList<PropertyDescriptor>();
            java.lang.reflect.Field[] fields = clasz.getDeclaredFields();

            for (java.lang.reflect.Field field : fields) {
                if (!Modifier.isStatic(field.getModifiers())) {
                    SimplePropertyDescriptor simpleProperty = new SimplePropertyDescriptor();
                    simpleProperty.annotation = field.getAnnotation(Field.class);
                    if (simpleProperty.annotation != null) {
                        simpleProperty.field = field;
                        simpleProperty.dbFieldName = field.getName();
                        if (!simpleProperty.annotation.fieldName().isEmpty())
                            simpleProperty.dbFieldName = simpleProperty.annotation.fieldName();
                        final String setterName = String.format("set%s%s", field.getName().substring(0, 1).toUpperCase(), field.getName().substring(1));
                        try {
                            simpleProperty.setter = masterClasz.getMethod(setterName, field.getType());
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        }
                        final boolean isBoolean = field.getType().equals(boolean.class) || field.getType().equals(Boolean.class);
                        final String getterName = String.format("%s%s%s", isBoolean ? "is" : "get", field.getName().substring(0, 1).toUpperCase(), field.getName().substring(1));
                        try {
                            simpleProperty.getter = masterClasz.getMethod(getterName);
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        }
                        result.add(simpleProperty);
                    }
                    MultiplePropertyDescriptor multipleProperty = new MultiplePropertyDescriptor();
                    multipleProperty.annotation = field.getAnnotation(OneToMany.class);
                    if (multipleProperty.annotation != null) {
                        multipleProperty.field = field;
                        Type type = field.getGenericType();
                        if (type instanceof ParameterizedType) {
                            ParameterizedType pt = (ParameterizedType) type;
                            multipleProperty.subBeanType = (Class<? extends CommonBean>) pt.getActualTypeArguments()[0];
                        }

                        final String getterName = String.format("%s%s%s", "get", field.getName().substring(0, 1).toUpperCase(), field.getName().substring(1));
                        try {
                            multipleProperty.getter = masterClasz.getMethod(getterName);
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        }
                        result.add(multipleProperty);
                    }
                }
            }

            Class<? extends CommonBean> superClass = (Class<? extends CommonBean>) clasz.getSuperclass();
            if (!superClass.equals(CommonBean.class))
                result.addAll(buildPropertiesDescriptors(masterClasz, superClass));

            propertyDescriptorsList.put(clasz, result);
        }
        return result;
    }

    @SuppressWarnings({"unchecked", "StringConcatenationMissingWhitespace"})
    public static SQLDescriptor getSQLDescriptor(Class<? extends CommonBean> clasz) {
        SQLDescriptor result = sqlDescriptorsList.get(clasz);
        if (result == null) {
            result = new SQLDescriptor();
            // au cas où l'instanciation du BeanFactory appelerait getSQLDescriptor
            sqlDescriptorsList.put(clasz, result);
            result.beanClass = clasz;
            Entity a = clasz.getAnnotation(Entity.class);
            if (!a.tableName().isEmpty())
                result.tableName = a.tableName();
            else
                result.tableName = clasz.getSimpleName().toUpperCase() + "S";
            if (BeanFactory.class.isAssignableFrom(a.factoryClass()))
                try {
                    result.factory = (BeanFactory) a.factoryClass().getConstructor().newInstance();
                } catch (InstantiationException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                }
            List<PropertyDescriptor> properties = getPropertiesDescriptors(clasz);
            for (PropertyDescriptor property : properties) {
                if (property instanceof SimplePropertyDescriptor) {
                    SimplePropertyDescriptor simpleProperty = (SimplePropertyDescriptor) property;
                    if (simpleProperty.annotation.primaryKey())
                        result.primaryKey = simpleProperty;
                    final Class<?> propertyType = property.getField().getType();
                    if (CommonBean.class.isAssignableFrom(propertyType))
                        result.columns.put(simpleProperty, getSQLDescriptor((Class<? extends CommonBean>) propertyType));
                    else
                        result.columns.put(simpleProperty, null);
                }
            }
        }
        return result;
    }

    public static QueryInfo getQueryInfo(Class<? extends CommonBean> clasz) {
        QueryInfo queryInfo = queryInfoList.get(clasz);
        if (queryInfo == null) {
            queryInfo = getQueryInfo(getSQLDescriptor(clasz));
            queryInfoList.put(clasz, queryInfo);
        }
        return queryInfo;
    }

    public static QueryInfo getQueryInfo(SQLDescriptor descriptor) {
        return buildQueryInfo(descriptor, null, null, null, 0);
    }

    private static QueryInfo buildQueryInfo(SQLDescriptor descriptor, SQLDescriptor masterDescriptor, String masterTableAlias, PropertySQLDescriptor masterField, Integer indicator) {
        QueryInfo queryInfo = new QueryInfo();
        queryInfo.beanClass = descriptor.beanClass;
        if (indicator != null) queryInfo.indicator = indicator;

        String tableAlias = getSQLAlias(descriptor.getTableName(), queryInfo.indicator);

        if (masterField == null)
            queryInfo.tables.add(String.format("%s %s", descriptor.tableName, tableAlias));
        else {
            String join = String.format("%s.%s=%s", tableAlias, descriptor.primaryKey.dbFieldName, masterField.fullFieldName);
            queryInfo.tables.add(String.format((masterField.isNullable() ? "LEFT" : "INNER") + " JOIN %s %s ON (%s)", descriptor.tableName, tableAlias, join));
        }

        int localIndicator = queryInfo.indicator;

        for (Map.Entry<SimplePropertyDescriptor, SQLDescriptor> column : descriptor.getColumns().entrySet()) {
            PropertySQLDescriptor property = new PropertySQLDescriptor();

            property.property = column.getKey();
            String fieldName = property.property.dbFieldName;
            property.aliasName = getSQLAlias(fieldName, localIndicator);
            property.fullFieldName = String.format("%s.%s", tableAlias, fieldName);

            queryInfo.fields.add(property.fullFieldName);
            queryInfo.sqlAliasMapping.put(property.fullFieldName, String.format("%s %s", property.fullFieldName, property.aliasName));
            queryInfo.loadDescriptor.getAlias().put(column.getKey(), property.aliasName);
            queryInfo.columns.put(property.property.getField(), property);

            if (column.getValue() != null) {
                property.masterProperty = masterField;
                final QueryInfo childQueryInfo = buildQueryInfo(column.getValue(), descriptor, tableAlias, property, ++queryInfo.indicator);
                queryInfo.indicator = childQueryInfo.indicator;
                queryInfo.tables.addAll(childQueryInfo.tables);
                queryInfo.fields.addAll(childQueryInfo.fields);
                queryInfo.loadDescriptor.getChildAlias().put(property.aliasName, childQueryInfo.loadDescriptor);
                queryInfo.sqlAliasMapping.putAll(childQueryInfo.sqlAliasMapping);
                queryInfo.columns.putAll(childQueryInfo.columns);
            }
        }
        return queryInfo;
    }

}
