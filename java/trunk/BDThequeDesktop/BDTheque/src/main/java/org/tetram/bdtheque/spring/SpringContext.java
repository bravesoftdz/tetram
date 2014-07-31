/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SpringContext.java
 * Last modified by Tetram, on 2014-07-31T16:50:01CEST
 */

package org.tetram.bdtheque.spring;

import org.apache.commons.lang3.StringEscapeUtils;
import org.jetbrains.annotations.NonNls;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.tetram.bdtheque.data.services.ApplicationContextImpl;
import org.tetram.bdtheque.data.services.UserPreferences;
import org.tetram.bdtheque.data.services.UserPreferencesImpl;
import org.tetram.bdtheque.utils.StringUtils;

import java.util.ArrayList;

/**
 * Created by Thierry on 21/06/2014.
 */
@Configuration
public class SpringContext {
    @NonNls
    public static final String SPRING_CONFIG_XML = "/org/tetram/bdtheque/config/spring-config.xml";

    @NonNls
    public static final ApplicationContext CONTEXT;

    static {
        GenericApplicationContext context = new AnnotationConfigApplicationContext();
        XmlBeanDefinitionReader xmlReader = new XmlBeanDefinitionReader(context);
        xmlReader.loadBeanDefinitions(new ClassPathResource(SpringContext.SPRING_CONFIG_XML));
        // PropertiesBeanDefinitionReader propReader = new PropertiesBeanDefinitionReader(context);
        // propReader.loadBeanDefinitions(new ClassPathResource("otherBeans.properties"));
        context.refresh();

        CONTEXT = context;
    }

    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_CONFIG_DEFAULT_DATABASE_PROPERTIES = "/org/tetram/bdtheque/config/default_database.properties";
    @NonNls
    private static final String ORG_TETRAM_BDTHEQUE_CONFIG_DATABASE_PROPERTIES = "/org/tetram/bdtheque/config/database.properties";
    @NonNls
    private static final String JDBC_PREFIX = "database.url=jdbc:firebirdsql:%s:%s";

    @Bean(name = "databaseProperties")
    public static PropertySourcesPlaceholderConfigurer properties() {
        // on utilise par getBean puisque Spring n'est pas encore chargé
        ApplicationContextImpl applicationContext = new ApplicationContextImpl();
        UserPreferences userPreferences = new UserPreferencesImpl(applicationContext);

        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();
        ArrayList<Resource> resources = new ArrayList<>();

        // l'ordre des ressources est important !!
        resources.add(new ClassPathResource(ORG_TETRAM_BDTHEQUE_CONFIG_DATABASE_PROPERTIES, SpringContext.class.getClassLoader()));
        resources.add(new ClassPathResource(ORG_TETRAM_BDTHEQUE_CONFIG_DEFAULT_DATABASE_PROPERTIES, SpringContext.class.getClassLoader()));
        //resources.add(new FileSystemResource(applicationContext.getUserConfigFile()));
        if (userPreferences.getDatabase() != null && userPreferences.getDatabase().exists()) {
            final String s = StringEscapeUtils.escapeJava(userPreferences.getDatabase().getAbsolutePath());
            @NonNls String serveur = userPreferences.getDatabaseServer();
            if (StringUtils.isNullOrEmpty(serveur)) serveur = "embedded";
            resources.add(new ByteArrayResource(String.format(JDBC_PREFIX, serveur, s).getBytes()));
        }

        configurer.setLocations(resources.toArray(new Resource[resources.size()]));
        configurer.setIgnoreUnresolvablePlaceholders(true);
        return configurer;
    }
}
