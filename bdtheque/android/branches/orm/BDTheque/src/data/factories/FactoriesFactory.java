package org.tetram.bdtheque.data.factories;

import org.jetbrains.annotations.Nullable;
import org.tetram.bdtheque.data.bean.CommonBean;
import org.tetram.bdtheque.data.utils.Entity;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings({"ClassNamePrefixedWithPackageName", "UnusedDeclaration"})
public class FactoriesFactory {

    private static final Map<Class<? extends BeanFactory<?>>, BeanFactory<?>> factories = new HashMap<>();
    private static final Map<Class<? extends CommonBean>, BeanFactory<?>> factoriesBean = new HashMap<>();

    @SuppressWarnings("unchecked")
    public static <T extends BeanFactory<?>> T getFactory(Class<T> factoryClass) {
        BeanFactory<?> factory = factories.get(factoryClass);
        if (factory == null)
            try {
                Constructor<T> constructor = factoryClass.getConstructor();
                factory = constructor.newInstance();
                factories.put(factoryClass, factory);
            } catch (InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
                e.printStackTrace();
            }
        return (T) factory;
    }

    @Nullable
    @SuppressWarnings("unchecked")
    public static <T extends BeanFactory<?>, B extends CommonBean> T getFactoryForBean(Class<B> beanClass) {
        BeanFactory<?> factory = factoriesBean.get(beanClass);
        if (factory == null) {
            Entity e = beanClass.getAnnotation(Entity.class);
            if (e == null) return null;
            factory = getFactory(e.factoryClass());
            factoriesBean.put(beanClass, factory);
        }
        return (T) factory;
    }

    public static <T extends BeanFactory<?>, B extends CommonBean> T getFactoryForBean(B bean) {
        return getFactoryForBean(bean.getClass());
    }
}
