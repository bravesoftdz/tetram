package org.tetram.bdtheque.data.orm;

import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.orm.annotations.DefaultBooleanValue;
import org.tetram.bdtheque.data.orm.annotations.Filter;
import org.tetram.bdtheque.data.orm.annotations.Order;
import org.tetram.bdtheque.utils.StringUtils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public abstract class BeanLoader {
    private BeanLoader() {
        super();
    }

    @Nullable
    @SuppressWarnings("unchecked")
    public static <T extends CommonBean> T loadFromCursor(Class<T> beanClass, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor) {
        T bean = null;
        try {
            bean = beanClass.getConstructor().newInstance();
        } catch (final InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }
        LoadResult res = loadByAnnotation(cursor, inline, loadDescriptor, bean);
        switch (res) {
            case NOTFOUND:
                return null;
            case ERROR:
            case OK:
            default:
                SQLDescriptor descriptor = Core.getSQLDescriptor(beanClass);
                if ((descriptor.factory != null) && !descriptor.factory.loadFromCursor(cursor, inline, loadDescriptor, bean))
                    return null;
                return bean;
        }
    }

    private static <T extends CommonBean> LoadResult loadByAnnotation(Cursor cursor, boolean inline, LoadDescriptor loadDescriptor, T bean) {
        List<PropertyDescriptor> fields = Core.getPropertiesDescriptors(bean.getClass());
        if (fields.isEmpty()) return LoadResult.ERROR;

        SQLDescriptor descriptor = Core.getSQLDescriptor(bean.getClass());

        String dbFieldName = descriptor.getPrimaryKey().getDbFieldName();
        if (loadDescriptor != null)
            dbFieldName = loadDescriptor.getAlias().get(descriptor.getPrimaryKey());
        bean.setId(FieldLoader.getFieldAsUUID(cursor, dbFieldName));
        if (bean.getId() == null) return LoadResult.NOTFOUND;

        for (final PropertyDescriptor property : fields)
            if (!property.equals(descriptor.getPrimaryKey()))
                loadProperty(bean, property, cursor, inline, loadDescriptor);

        return LoadResult.ERROR;
    }

    private static <T extends CommonBean> void loadProperty(T bean, PropertyDescriptor property, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor) {
        if (property instanceof SimplePropertyDescriptor)
            loadSimpleProperty(bean, (SimplePropertyDescriptor) property, cursor, inline, loadDescriptor);
        else if (property instanceof MultiplePropertyDescriptor)
            if (!((MultiplePropertyDescriptor) property).annotation.useFactory())
                loadMultipleProperty(bean, (MultiplePropertyDescriptor) property);
    }

    @SuppressWarnings("unchecked")
    private static <T extends CommonBean> void loadSimpleProperty(T bean, SimplePropertyDescriptor descriptor, Cursor cursor, boolean inline, LoadDescriptor loadDescriptor) {
        final Class<?> fieldType = descriptor.getField().getType();
        try {
            String dbFieldName = descriptor.getDbFieldName();
            if (loadDescriptor != null)
                dbFieldName = loadDescriptor.getAlias().get(descriptor);
            if (fieldType.equals(String.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsString(cursor, dbFieldName));
            else if (fieldType.equals(Integer.class) || fieldType.equals(int.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsInteger(cursor, dbFieldName));
            else if (fieldType.equals(Double.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsDouble(cursor, dbFieldName));
            else if (fieldType.equals(Date.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsDate(cursor, dbFieldName));
            else if (fieldType.equals(Boolean.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsBoolean(cursor, dbFieldName));
            else if (fieldType.equals(boolean.class)) {
                DefaultBooleanValue defaultBooleanValue = descriptor.getField().getAnnotation(DefaultBooleanValue.class);
                if (defaultBooleanValue == null)
                    descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsBool(cursor, dbFieldName));
                else
                    descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsBool(cursor, dbFieldName, defaultBooleanValue.value()));
            } else if (fieldType.isEnum()) {
                Method enumFromValue;
                try {
                    enumFromValue = fieldType.getMethod("fromValue", int.class);
                } catch (final NoSuchMethodException e) {
                    enumFromValue = fieldType.getMethod("fromValue", Integer.class);
                }
                descriptor.getSetter().invoke(bean, enumFromValue.invoke(null, FieldLoader.getFieldAsInteger(cursor, dbFieldName)));
            } else if (CommonBean.class.isAssignableFrom(fieldType)) {
                LoadDescriptor childLoadDescriptor = null;
                if (loadDescriptor != null)
                    childLoadDescriptor = loadDescriptor.getChildAlias().get(dbFieldName);
                if (inline) {
                    descriptor.getSetter().invoke(bean, loadFromCursor((Class<? extends CommonBean>) fieldType, cursor, inline, childLoadDescriptor));
                } else {
                    final UUID subBeanId = FieldLoader.getFieldAsUUID(cursor, dbFieldName);
                    if (subBeanId != null)
                        descriptor.getSetter().invoke(bean, BeanDao.getById((Class<? extends CommonBean>) fieldType, subBeanId));
                }
            } else if (fieldType.equals(UUID.class))
                descriptor.getSetter().invoke(bean, FieldLoader.getFieldAsUUID(cursor, dbFieldName));
            else if (fieldType.equals(URL.class))
                descriptor.getSetter().invoke(bean, new URL(FieldLoader.getFieldAsString(cursor, dbFieldName)));
        } catch (final NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        } catch (final MalformedURLException ignored) {
        }
    }

    @SuppressWarnings({"unchecked", "StringBufferReplaceableByString"})
    private static <T extends CommonBean, B extends CommonBean> void loadMultipleProperty(T bean, MultiplePropertyDescriptor property) {
        try {
            List<B> list = (List<B>) property.getGetter().invoke(bean);
            list.clear();

            QueryInfo queryInfo = Core.getQueryInfo(property.beanClass);

            StringBuilder filtre = new StringBuilder(150);
            filtre.append(String.format("%s = ?", queryInfo.getFullFieldname(property.getAnnotation().mappedBy())));
            if (property.getFilters() != null)
                for (final Filter filter : property.getFilters().value())
                    filtre.append(String.format(" and (%s = %s)", queryInfo.getFullFieldname(filter.field()), filter.value()));

            StringBuilder orderBy = new StringBuilder(150);
            if (property.getOrderBy() != null)
                for (final Order order : property.getOrderBy().value())
                    orderBy.append(queryInfo.getFullFieldname(order.field())).append(order.asc() ? "" : " DESC");

            list.clear();
            List<B> tmpList = (List<B>) BeanDao.getList(property.beanClass, filtre.toString(), new String[]{StringUtils.UUIDToGUIDString(bean.getId())}, orderBy.toString());
            list.addAll(tmpList);
        } catch (final IllegalAccessException | InvocationTargetException e) {
            e.printStackTrace();
        }
    }

}
