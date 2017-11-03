/*
 * Copyright (c) 2014, tetram.org. All Rights Reserved.
 * SpringContextTest.java
 * Last modified by Tetram, on 2014-07-29T11:02:08CEST
 */

package org.tetram.bdtheque.data;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.tetram.bdtheque.data.bean.Personne;
import org.tetram.bdtheque.data.dao.PersonneDao;

/**
 * Created by Thierry on 02/06/2014.
 */
public class SpringContextTest {

    @NonNls
    public static final String ORG_TETRAM_BDTHEQUE_CONFIG_SPRING_CONFIG_XML = "org/tetram/bdtheque/config/spring-config.xml";

    @Test
    public void testGetContext() throws Exception {

        AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
        XmlBeanDefinitionReader xmlReader = new XmlBeanDefinitionReader(ctx);
        xmlReader.loadBeanDefinitions(new ClassPathResource(ORG_TETRAM_BDTHEQUE_CONFIG_SPRING_CONFIG_XML));
        // PropertiesBeanDefinitionReader propReader = new PropertiesBeanDefinitionReader(ctx);
        // propReader.loadBeanDefinitions(new ClassPathResource("otherBeans.properties"));
        ctx.refresh();
        Assert.assertNotNull(ctx);

/*
        EditeurMapper editeurMapper = ctx.getBean(EditeurMapper.class);
        Assert.assertNotNull(editeurMapper);

        EditeurLite editeurLite = editeurMapper.getEditeurLiteById(Constants.ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeurLite);
        Assert.assertEquals(Constants.ID_EDITEUR_GLENAT, editeurLite.getId());

        Editeur editeur = editeurMapper.getEditeurById(Constants.ID_EDITEUR_GLENAT);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(editeur);
        Assert.assertEquals(Constants.ID_EDITEUR_GLENAT, editeur.getId());
*/

        PersonneDao personneDao = ctx.getBean(PersonneDao.class);
        Assert.assertNotNull(personneDao);

        Personne personne = personneDao.get(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(personne);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, personne.getId());
        Assert.assertNotNull(personne.getSeries());
        Assert.assertFalse(personne.getSeries().isEmpty());
    }
}
