package org.tetram.bdtheque;

import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.core.io.ClassPathResource;

/**
 * Created by Thierry on 21/06/2014.
 */
public class SpringContext {
    @NonNls
    public static final String SPRING_CONFIG_XML = "/org/tetram/bdtheque/config/spring-config.xml";

    private static SpringContext ourInstance = null;
    private final GenericApplicationContext context;

    private SpringContext() {
        context = new AnnotationConfigApplicationContext();
        XmlBeanDefinitionReader xmlReader = new XmlBeanDefinitionReader(context);
        xmlReader.loadBeanDefinitions(new ClassPathResource(SpringContext.SPRING_CONFIG_XML));
        // PropertiesBeanDefinitionReader propReader = new PropertiesBeanDefinitionReader(context);
        // propReader.loadBeanDefinitions(new ClassPathResource("otherBeans.properties"));
        context.refresh();
    }

    public static SpringContext getInstance() {
        if (ourInstance == null)
            ourInstance = new SpringContext();
        return ourInstance;
    }

    public GenericApplicationContext getContext() {
        return context;
    }
}
