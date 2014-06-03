package org.tetram.bdtheque.data;

import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.core.io.ClassPathResource;

/**
 * Created by Thierry on 24/05/2014.
 */
public class Database {

    private static Database ourInstance = null;
    final private GenericApplicationContext ctx;

    private Database() {
        super();

        setFBLogged(true);

        ctx = new AnnotationConfigApplicationContext();
        XmlBeanDefinitionReader xmlReader = new XmlBeanDefinitionReader(ctx);
        xmlReader.loadBeanDefinitions(new ClassPathResource("org/tetram/bdtheque/config/spring-config.xml"));
        // PropertiesBeanDefinitionReader propReader = new PropertiesBeanDefinitionReader(ctx);
        // propReader.loadBeanDefinitions(new ClassPathResource("otherBeans.properties"));
        ctx.refresh();
    }

    public static Database getInstance() {
        if (ourInstance == null)
            ourInstance = new Database();
        return ourInstance;
    }

    static public boolean isFBLogged() {
        return Boolean.getBoolean("FBLog4j");
    }

    static public void setFBLogged(boolean value) {
        if (isFBLogged() != value)
            System.setProperty("FBLog4j", String.valueOf(value));
    }

    public GenericApplicationContext getApplicationContext() {
        return ctx;
    }
}
