package org.tetram.bdtheque.data.utils;

import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.utils.StringUtils;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@SuppressWarnings("UnusedDeclaration")
public abstract class DaoUtils {

    public static final int MAX_SQL_ALIAS_LENGTH = 25;
    private static final Map<Class<? extends CommonBean>, List<PropertyDescriptor>> propertyDescriptorsList = new HashMap<Class<? extends CommonBean>, List<PropertyDescriptor>>();
    private static final Map<Class<? extends CommonBean>, SQLDescriptor> sqlDescriptorsList = new HashMap<Class<? extends CommonBean>, SQLDescriptor>();
    private static final SimpleDateFormat simpleDateTimeFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss.zzz");
    private static final SimpleDateFormat sqlDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.zzz");
    private static final SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM/dd/yyyy");
    private static final SimpleDateFormat sqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static Map<Class<? extends CommonBean>, QueryInfo> queryInfoList = new HashMap<Class<? extends CommonBean>, QueryInfo>();

    private DaoUtils() {
        super();
    }

    @Nullable
    public static UUID getFieldAsUUID(Cursor cursor, String fieldName) {
        String s = getFieldAsString(cursor, fieldName);
        return (s == null) ? null : StringUtils.GUIDStringToUUID(s);
    }

    @Nullable
    public static String getFieldAsString(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        return cursor.getString(columnIndex);
    }

    @Nullable
    public static Double getFieldAsDouble(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_STRING:
                return Double.valueOf(cursor.getString(columnIndex));
            default:
                return cursor.getDouble(columnIndex);
        }
    }

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    public static boolean getFieldAsBool(Cursor cursor, String fieldName) {
        return getFieldAsBool(cursor, fieldName, false);
    }

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    public static boolean getFieldAsBool(Cursor cursor, String fieldName, boolean defaut) {
        Boolean fieldAsBoolean = getFieldAsBoolean(cursor, fieldName);
        if (fieldAsBoolean == null)
            return defaut;
        else
            return fieldAsBoolean;
    }

    @SuppressWarnings("BooleanMethodNameMustStartWithQuestion")
    @Nullable
    public static Boolean getFieldAsBoolean(Cursor cursor, String fieldName) {
        Integer i = getFieldAsInteger(cursor, fieldName);
        if (i == null) return null;
        return (i != 0);
    }

    @Nullable
    public static Integer getFieldAsInteger(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_STRING:
                return Integer.valueOf(cursor.getString(columnIndex));
            default:
                return cursor.getInt(columnIndex);
        }
    }

    @Nullable
    public static Date getFieldAsDate(Cursor cursor, String fieldName) {
        int columnIndex = cursor.getColumnIndex(fieldName);
        if (columnIndex == -1) columnIndex = cursor.getColumnIndex(fieldName.toLowerCase());
        if (columnIndex == -1) return null;
        if (cursor.isNull(columnIndex)) return null;

        switch (cursor.getType(columnIndex)) {
            case Cursor.FIELD_TYPE_INTEGER:
                return new Date(cursor.getInt(columnIndex));
            case Cursor.FIELD_TYPE_STRING:
                try {
                    final String dateString = cursor.getString(columnIndex);
                    if (dateString.contains("/"))
                        return simpleDateFormat.parse(dateString);
                    else
                        return sqlDateFormat.parse(dateString);
                } catch (ParseException e) {
                    e.printStackTrace();
                    return null;
                }
            default:
                return null; // new Date(cursor.getDouble(columnIndex));
        }

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
            // l'instanciation du BeanFactory va appeler getSQLDescriptor
            sqlDescriptorsList.put(clasz, result);
            result.beanClass = clasz;
            Entity a = clasz.getAnnotation(Entity.class);
            if (!a.tableName().isEmpty())
                result.tableName = a.tableName();
            else
                result.tableName = clasz.getSimpleName().toUpperCase() + "S";
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

    public static String getSQLAlias(String sqlName, int indicator) {
        int aliasLength = MAX_SQL_ALIAS_LENGTH - 1 - ((indicator == 0) ? 1 : ((int) Math.ceil(Math.log10(indicator)) + 1));
        return String.format("%s_%d", (sqlName.length() <= aliasLength) ? sqlName : sqlName.substring(0, aliasLength), indicator);
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

    public static String getFullFieldname(DaoUtils.QueryInfo queryInfo, String fieldName) {
        return getFullFieldname(queryInfo, queryInfo.beanClass, fieldName);
    }

    public static String getFullFieldname(DaoUtils.QueryInfo queryInfo, Class<? extends CommonBean> beanClass, String fieldName) {
        java.lang.reflect.Field fieldNomGenre = DaoUtils.getPrivateField(beanClass, fieldName);
        DaoUtils.PropertySQLDescriptor property = queryInfo.getColumns().get(fieldNomGenre);
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

    public static class PropertyDescriptor {
        protected java.lang.reflect.Field field;
        protected Method setter;
        protected Method getter;

        public java.lang.reflect.Field getField() {
            return this.field;
        }

        public Method getGetter() {
            return this.getter;
        }

        public Method getSetter() {
            return this.setter;
        }

    }

    public static class SimplePropertyDescriptor extends PropertyDescriptor {
        private Field annotation;
        private String dbFieldName;

        public Field getAnnotation() {
            return this.annotation;
        }

        public String getDbFieldName() {
            return this.dbFieldName;
        }
    }

    public static class PropertySQLDescriptor {
        private SimplePropertyDescriptor property;
        private String aliasName;
        private String fullFieldName;
        private PropertySQLDescriptor masterProperty;

        public SimplePropertyDescriptor getProperty() {
            return this.property;
        }

        public String getAliasName() {
            return this.aliasName;
        }

        public String getFullFieldName() {
            return this.fullFieldName;
        }

        public boolean isNullable() {
            boolean result = this.property.annotation.nullable();
            if (this.masterProperty != null)
                result = result || this.masterProperty.isNullable();
            return result;
        }

        public PropertySQLDescriptor getMasterProperty() {
            return this.masterProperty;
        }
    }

    public static class SQLDescriptor {
        public Class<? extends CommonBean> beanClass;
        private String tableName;
        private SimplePropertyDescriptor primaryKey;
        private Map<SimplePropertyDescriptor, SQLDescriptor> columns = new HashMap<SimplePropertyDescriptor, SQLDescriptor>();

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

    public static class LoadDescriptor {
        private final Map<SimplePropertyDescriptor, String> alias = new HashMap<SimplePropertyDescriptor, String>();
        private final Map<String, LoadDescriptor> childAlias = new HashMap<String, LoadDescriptor>();

        public Map<SimplePropertyDescriptor, String> getAlias() {
            return this.alias;
        }

        public Map<String, LoadDescriptor> getChildAlias() {
            return this.childAlias;
        }
    }

    public static class QueryInfo {
        /**
         * utilisé uniquement en interne pour générer les alias
         */
        private int indicator;
        private Class<? extends CommonBean> beanClass;
        private List<String> tables = new ArrayList<String>();
        private List<String> fields = new ArrayList<String>();
        private LoadDescriptor loadDescriptor = new LoadDescriptor();
        private Map<String, String> sqlAliasMapping = new HashMap<String, String>();
        private Map<java.lang.reflect.Field, PropertySQLDescriptor> columns = new HashMap<java.lang.reflect.Field, PropertySQLDescriptor>();

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
    }

    public static class MultiplePropertyDescriptor extends PropertyDescriptor {
        private OneToMany annotation;

        private OneToMany getAnnotation() {
            return this.annotation;
        }

    }
}
