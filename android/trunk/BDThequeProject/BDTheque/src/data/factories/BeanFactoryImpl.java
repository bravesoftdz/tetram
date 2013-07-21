package org.tetram.bdtheque.data.factories;

import android.content.Context;
import android.database.Cursor;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.dao.CommonDao;
import org.tetram.bdtheque.data.dao.DaoFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.DefaultBooleanValue;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.data.utils.Field;
import org.tetram.bdtheque.utils.GenericUtils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBool;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsBoolean;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDate;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsDouble;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsInteger;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsString;
import static org.tetram.bdtheque.data.utils.DaoUtils.getFieldAsUUID;

public abstract class BeanFactoryImpl<T extends CommonBean> implements BeanFactory<T> {

    @SuppressWarnings({"FieldCanBeLocal", "UnusedDeclaration"})
    private String tableName;
    private String[] primaryKey;

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

    private static class PropertyDescriptor {
        Field annotation;
        java.lang.reflect.Field field;
        String dbFieldName;
        Method setter;
        Method getter;
    }

    private final Class<? extends CommonBean> beanClass;
    private static final Map<Class, List<PropertyDescriptor>> annotationsList = new HashMap<>();

    @SuppressWarnings("unchecked")
    public BeanFactoryImpl() {
        super();
        this.beanClass = (Class<? extends CommonBean>) GenericUtils.getTypeArguments(BeanFactoryImpl.class, getClass()).get(0);
        Entity a = this.beanClass.getAnnotation(Entity.class);
        if (a != null) {
            this.tableName = a.tableName();
            if (a.primaryKey().length == 0)
                this.primaryKey = new String[]{"id_" + a.tableName()};
            else
                this.primaryKey = a.primaryKey();
        }
    }

    @Override
    public boolean loadFromCursor(Context context, Cursor cursor, T bean) {
        return true;
    }

    @SuppressWarnings("unchecked")
    @Nullable
    @Override
    public T loadFromCursor(Context context, Cursor cursor) {
        T bean = null;
        try {
            bean = (T) this.beanClass.getConstructor().newInstance();
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
            e.printStackTrace();
        }
        LoadResult res = loadByAnnotation(context, cursor, bean);
        switch (res) {
            case NOTFOUND:
                return null;
            case ERROR:
            case OK:
            default:
                if (!loadFromCursor(context, cursor, bean))
                    return null;
                return bean;
        }
    }

    private void loadProperty(T bean, PropertyDescriptor descriptor, Cursor cursor, Context context) {
        final Class<?> fieldType = descriptor.field.getType();
        try {
            if (fieldType.equals(String.class))
                descriptor.setter.invoke(bean, getFieldAsString(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(Integer.class) || fieldType.equals(int.class))
                descriptor.setter.invoke(bean, getFieldAsInteger(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(Double.class))
                descriptor.setter.invoke(bean, getFieldAsDouble(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(Date.class))
                descriptor.setter.invoke(bean, getFieldAsDate(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(Boolean.class))
                descriptor.setter.invoke(bean, getFieldAsBoolean(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(boolean.class)) {
                DefaultBooleanValue defaultBooleanValue = descriptor.field.getAnnotation(DefaultBooleanValue.class);
                if (defaultBooleanValue == null)
                    descriptor.setter.invoke(bean, getFieldAsBool(cursor, descriptor.dbFieldName));
                else
                    descriptor.setter.invoke(bean, getFieldAsBool(cursor, descriptor.dbFieldName, defaultBooleanValue.value()));
            } else if (fieldType.isEnum()) {
                Method enumFromValue = fieldType.getMethod("fromValue", int.class);
                descriptor.setter.invoke(bean, enumFromValue.invoke(null, getFieldAsInteger(cursor, descriptor.dbFieldName)));
            } else if (CommonBean.class.isAssignableFrom(fieldType)) {
                BeanDaoClass daoClass = descriptor.field.getAnnotation(BeanDaoClass.class);
                if (daoClass == null)
                    daoClass = fieldType.getAnnotation(BeanDaoClass.class);
                if (daoClass == null) {
                    Entity e = fieldType.getAnnotation(Entity.class);
                    BeanFactory factory = e.factoryClass().getConstructor().newInstance();
                    descriptor.setter.invoke(bean, factory.loadFromCursor(context, cursor));
                } else {
                    final CommonDao dao = DaoFactory.getDao(daoClass.value(), context);
                    final UUID subBeanId = getFieldAsUUID(cursor, descriptor.dbFieldName);
                    if (subBeanId != null) descriptor.setter.invoke(bean, dao.getById(subBeanId));
                }
            } else if (fieldType.equals(UUID.class))
                descriptor.setter.invoke(bean, getFieldAsUUID(cursor, descriptor.dbFieldName));
            else if (fieldType.equals(URL.class))
                descriptor.setter.invoke(bean, new URL(getFieldAsString(cursor, descriptor.dbFieldName)));
            else /*if (List.class.isAssignableFrom(fieldType))*/ {

            }
        } catch (IllegalAccessException | InvocationTargetException | InstantiationException | NoSuchMethodException e) {
            e.printStackTrace();
        } catch (MalformedURLException ignored) {
        }
    }

    private LoadResult loadByAnnotation(Context context, Cursor cursor, T bean) {
        List<PropertyDescriptor> fields = buildAnnotationList(this.beanClass);
        if (fields.isEmpty()) return LoadResult.ERROR;

        bean.setId(getFieldAsUUID(cursor, this.primaryKey[0]));
        if (bean.getId() == null) return LoadResult.NOTFOUND;

        for (PropertyDescriptor property : fields)
            loadProperty(bean, property, cursor, context);

        return LoadResult.ERROR;
    }

    public static List<PropertyDescriptor> buildAnnotationList(Class<? extends CommonBean> masterClasz) {
        return buildAnnotationList(masterClasz, masterClasz);
    }

    @SuppressWarnings({"unchecked", "VariableNotUsedInsideIf"})
    private static List<PropertyDescriptor> buildAnnotationList(Class<? extends CommonBean> masterClasz, Class<? extends CommonBean> clasz) {
        List<PropertyDescriptor> result = annotationsList.get(clasz);
        if (null == result) {
            result = new ArrayList<>();
            java.lang.reflect.Field[] fields = clasz.getDeclaredFields();

            for (java.lang.reflect.Field field : fields) {
                if (!Modifier.isStatic(field.getModifiers())) {
                    PropertyDescriptor property = new PropertyDescriptor();
                    property.annotation = field.getAnnotation(Field.class);
                    if (property.annotation != null) {
                        property.field = field;
                        property.dbFieldName = field.getName();
                        if (!property.annotation.fieldName().equals(Field.DEFAULT_FIELDNAME))
                            property.dbFieldName = property.annotation.fieldName();
                        final String setterName = String.format("set%s%s", field.getName().substring(0, 1).toUpperCase(), field.getName().substring(1));
                        try {
                            property.setter = masterClasz.getMethod(setterName, field.getType());
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        }
                        final boolean isBoolean = field.getType().equals(boolean.class) || field.getType().equals(Boolean.class);
                        final String getterName = String.format("%s%s%s", isBoolean ? "is" : "get", field.getName().substring(0, 1).toUpperCase(), field.getName().substring(1));
                        try {
                            property.getter = masterClasz.getMethod(getterName);
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        }
                        result.add(property);
                    }
                }
            }

            Class superClass = clasz.getSuperclass();
            if (!superClass.equals(CommonBean.class))
                result.addAll(buildAnnotationList(masterClasz, superClass));

            annotationsList.put(clasz, result);
        }
        return result;
    }
}
