package org.tetram.bdtheque.data.orm;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.dao.CommonDao;
import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.orm.annotations.BeanDaoClass;
import org.tetram.bdtheque.data.orm.annotations.DefaultBooleanValue;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static org.tetram.bdtheque.data.orm.Core.getPropertiesDescriptors;
import static org.tetram.bdtheque.data.orm.Core.getQueryInfo;
import static org.tetram.bdtheque.data.orm.Core.getSQLDescriptor;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsBool;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsBoolean;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsDate;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsDouble;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsInteger;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsString;
import static org.tetram.bdtheque.data.orm.FieldLoader.getFieldAsUUID;

public abstract class BeanLoader {
    private BeanLoader() {
        super();
    }

    @Nullable
    @SuppressWarnings("unchecked")
    public static <T extends CommonBean> T loadFromCursor(Class<T> beanClass, Context context, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor) {
        T bean = null;
        try {
            bean = beanClass.getConstructor().newInstance();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        LoadResult res = loadByAnnotation(context, cursor, inline, loadDescriptor, bean);
        switch (res) {
            case NOTFOUND:
                return null;
            case ERROR:
            case OK:
            default:
//                if (!loadFromCursor(context, cursor, inline, loadDescriptor, bean))
//                    return null;
                return bean;
        }
    }

    private static <T extends CommonBean> LoadResult loadByAnnotation(Context context, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, T bean) {
        List<PropertyDescriptor> fields = getPropertiesDescriptors(bean.getClass());
        if (fields.isEmpty()) return LoadResult.ERROR;

        SQLDescriptor descriptor = getSQLDescriptor(bean.getClass());

        String dbFieldName = descriptor.getPrimaryKey().getDbFieldName();
        if (loadDescriptor != null)
            dbFieldName = loadDescriptor.getAlias().get(descriptor.getPrimaryKey());
        bean.setId(getFieldAsUUID(cursor, dbFieldName));
        if (bean.getId() == null) return LoadResult.NOTFOUND;

        for (PropertyDescriptor property : fields)
            if (!property.equals(descriptor.getPrimaryKey()))
                loadProperty(bean, property, cursor, context, inline, loadDescriptor);

        return LoadResult.ERROR;
    }

    private static <T extends CommonBean> void loadProperty(T bean, PropertyDescriptor property, Cursor cursor, Context context, boolean inline, LoadDescriptor loadDescriptor) {
        if (property instanceof SimplePropertyDescriptor)
            loadSimpleProperty(bean, (SimplePropertyDescriptor) property, cursor, context, inline, loadDescriptor);
        if (property instanceof MultiplePropertyDescriptor)
            loadMultipleProperty(bean, (MultiplePropertyDescriptor) property, cursor, context, inline, loadDescriptor);
    }

    @SuppressWarnings("unchecked")
    private static <T extends CommonBean> void loadSimpleProperty(T bean, SimplePropertyDescriptor descriptor, Cursor cursor, Context context, boolean inline, LoadDescriptor loadDescriptor) {
        final Class<?> fieldType = descriptor.getField().getType();
        try {
            String dbFieldName = descriptor.getDbFieldName();
            if (loadDescriptor != null)
                dbFieldName = loadDescriptor.getAlias().get(descriptor);
            if (fieldType.equals(String.class))
                descriptor.getSetter().invoke(bean, getFieldAsString(cursor, dbFieldName));
            else if (fieldType.equals(Integer.class) || fieldType.equals(int.class))
                descriptor.getSetter().invoke(bean, getFieldAsInteger(cursor, dbFieldName));
            else if (fieldType.equals(Double.class))
                descriptor.getSetter().invoke(bean, getFieldAsDouble(cursor, dbFieldName));
            else if (fieldType.equals(Date.class))
                descriptor.getSetter().invoke(bean, getFieldAsDate(cursor, dbFieldName));
            else if (fieldType.equals(Boolean.class))
                descriptor.getSetter().invoke(bean, getFieldAsBoolean(cursor, dbFieldName));
            else if (fieldType.equals(boolean.class)) {
                DefaultBooleanValue defaultBooleanValue = descriptor.getField().getAnnotation(DefaultBooleanValue.class);
                if (defaultBooleanValue == null)
                    descriptor.getSetter().invoke(bean, getFieldAsBool(cursor, dbFieldName));
                else
                    descriptor.getSetter().invoke(bean, getFieldAsBool(cursor, dbFieldName, defaultBooleanValue.value()));
            } else if (fieldType.isEnum()) {
                Method enumFromValue;
                try {
                    enumFromValue = fieldType.getMethod("fromValue", int.class);
                } catch (NoSuchMethodException e) {
                    enumFromValue = fieldType.getMethod("fromValue", Integer.class);
                }
                descriptor.getSetter().invoke(bean, enumFromValue.invoke(null, getFieldAsInteger(cursor, dbFieldName)));
            } else if (CommonBean.class.isAssignableFrom(fieldType)) {
                LoadDescriptor childLoadDescriptor = null;
                if (loadDescriptor != null)
                    childLoadDescriptor = loadDescriptor.getChildAlias().get(dbFieldName);
                if (inline) {
                    descriptor.getSetter().invoke(bean, loadFromCursor((Class<? extends CommonBean>) fieldType, context, cursor, inline, childLoadDescriptor));
                } else {
                    BeanDaoClass daoClass = descriptor.getField().getAnnotation(BeanDaoClass.class);
                    if (daoClass == null)
                        daoClass = fieldType.getAnnotation(BeanDaoClass.class);
                    if (daoClass == null) {
                        descriptor.getSetter().invoke(bean, loadFromCursor((Class<? extends CommonBean>) fieldType, context, cursor, inline, childLoadDescriptor));
                    } else {
                        final UUID subBeanId = getFieldAsUUID(cursor, dbFieldName);
                        if (subBeanId != null) {
                            final CommonDao dao = DaoFactory.getDao(daoClass.value(), context);
                            descriptor.getSetter().invoke(bean, dao.getById(subBeanId));
                        }
                    }
                }
            } else if (fieldType.equals(UUID.class))
                descriptor.getSetter().invoke(bean, getFieldAsUUID(cursor, dbFieldName));
            else if (fieldType.equals(URL.class))
                descriptor.getSetter().invoke(bean, new URL(getFieldAsString(cursor, dbFieldName)));
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (MalformedURLException ignored) {
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings({"UnusedParameters", "unchecked"})
    private static <T extends CommonBean> void loadMultipleProperty(T bean, MultiplePropertyDescriptor property, Cursor cursor, Context context, boolean inline, LoadDescriptor loadDescriptor) {
        try {
            List<? extends CommonBean> list = (List<? extends CommonBean>) property.getGetter().invoke(bean);
            list.clear();

            QueryInfo queryInfo = getQueryInfo(bean.getClass());

            String filtre = String.format("%s = ?", queryInfo.getFullFieldname(property.getAnnotation().mappedBy()));
            String order = null;
            if (!property.getAnnotation().orderBy().isEmpty())
                order = queryInfo.getFullFieldname(property.getAnnotation().orderBy());

/*
            new CommonDaoImpl<property.getSubBeanType()>();
            CommonDao<?> dao = DaoFactory.getDao(property.getSubBeanType(), context);
            List<? extends CommonBean> tmpList = dao.getList(filtre, new String[]{StringUtils.UUIDToGUIDString(bean.getId())}, order);
            list.addAll(tmpList);
*/

        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }

}
