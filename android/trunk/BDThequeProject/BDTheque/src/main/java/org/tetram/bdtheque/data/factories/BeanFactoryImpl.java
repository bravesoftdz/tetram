package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.abstracts.CommonBean;
import org.tetram.bdtheque.data.dao.CommonDao;
import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.DaoUtils;
import org.tetram.bdtheque.data.utils.DefaultBooleanValue;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.utils.GenericUtils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.PropertyDescriptor;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBool;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDate;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDouble;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public abstract class BeanFactoryImpl<T extends CommonBean> implements BeanFactory<T> {

    @SuppressWarnings({"FieldCanBeLocal", "UnusedDeclaration"})

    protected enum LoadResult {
        /**
         * L'entité a été chargée
         */
        OK,
        /**
         * L'entité contient des annotations @Field mais le curseur ne contient pas d'enregistrement à charger
         */
        NOTFOUND,
        /**
         * l'entité n'utilise pas les annotations @Field
         */
        ERROR
    }

    private final Class<T> beanClass;
    private final DaoUtils.SQLDescriptor descriptor;

    @SuppressWarnings("unchecked")
    public BeanFactoryImpl() {
        super();
        this.beanClass = (Class<T>) GenericUtils.getTypeArguments(BeanFactoryImpl.class, getClass()).get(0);
        this.descriptor = DaoUtils.getSQLDescriptor(this.beanClass);
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor, T bean) {
        return true;
    }

    @Nullable
    @SuppressWarnings("unchecked")
    @Override
    public T loadFromCursor(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor) {
        T bean = null;
        try {
            bean = this.beanClass.getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
        LoadResult res = loadByAnnotation(context, cursor, inline, loadDescriptor, bean);
        switch (res) {
            case NOTFOUND:
                return null;
            case ERROR:
            case OK:
            default:
                if (!loadFromCursor(context, cursor, inline, loadDescriptor, bean))
                    return null;
                return bean;
        }
    }

    private void loadProperty(T bean, PropertyDescriptor descriptor, Cursor cursor, Context context, boolean inline, DaoUtils.LoadDescriptor loadDescriptor) {
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
                DaoUtils.LoadDescriptor childLoadDescriptor = null;
                if (loadDescriptor != null)
                    childLoadDescriptor = loadDescriptor.getChildAlias().get(dbFieldName);
                if (inline) {
                    Entity e = fieldType.getAnnotation(Entity.class);
                    BeanFactory factory = e.factoryClass().getConstructor().newInstance();
                    descriptor.getSetter().invoke(bean, factory.loadFromCursor(context, cursor, inline, childLoadDescriptor));
                } else {
                    BeanDaoClass daoClass = descriptor.getField().getAnnotation(BeanDaoClass.class);
                    if (daoClass == null)
                        daoClass = fieldType.getAnnotation(BeanDaoClass.class);
                    if (daoClass == null) {
                        Entity e = fieldType.getAnnotation(Entity.class);
                        BeanFactory factory = e.factoryClass().getConstructor().newInstance();
                        descriptor.getSetter().invoke(bean, factory.loadFromCursor(context, cursor, inline, childLoadDescriptor));
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
            else /*if (List.class.isAssignableFrom(fieldType))*/ {

            }
        } catch (IllegalAccessException | InvocationTargetException | InstantiationException | NoSuchMethodException e) {
            e.printStackTrace();
        } catch (MalformedURLException ignored) {
        }
    }

    private LoadResult loadByAnnotation(Context context, Cursor cursor, boolean inline, DaoUtils.LoadDescriptor loadDescriptor, T bean) {
        List<PropertyDescriptor> fields = DaoUtils.getPropertiesDescriptors(this.beanClass);
        if (fields.isEmpty()) return LoadResult.ERROR;

        String dbFieldName = this.descriptor.getPrimaryKey().getDbFieldName();
        if (loadDescriptor != null)
            dbFieldName = loadDescriptor.getAlias().get(this.descriptor.getPrimaryKey());
        bean.setId(getFieldAsUUID(cursor, dbFieldName));
        if (bean.getId() == null) return LoadResult.NOTFOUND;

        for (PropertyDescriptor property : fields)
            loadProperty(bean, property, cursor, context, inline, loadDescriptor);

        return LoadResult.ERROR;
    }

}
