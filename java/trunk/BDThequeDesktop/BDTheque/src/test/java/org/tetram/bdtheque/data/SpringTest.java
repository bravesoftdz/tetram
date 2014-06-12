package org.tetram.bdtheque.data;

import org.jetbrains.annotations.NonNls;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.xml.XmlBeanDefinitionReader;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.core.io.ClassPathResource;
import org.tetram.bdtheque.data.bean.Auteur;
import org.tetram.bdtheque.data.dao.AuteurDao;

/**
 * Created by Thierry on 02/06/2014.
 */
public class SpringTest {

    @Test
    public void testGetContext() throws Exception {

        AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
        XmlBeanDefinitionReader xmlReader = new XmlBeanDefinitionReader(ctx);
        xmlReader.loadBeanDefinitions(new ClassPathResource("org/tetram/bdtheque/config/spring-config.xml"));
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

        AuteurDao auteurDao = ctx.getBean(AuteurDao.class);
        Assert.assertNotNull(auteurDao);

        Auteur auteur = auteurDao.get(Constants.ID_AUTEUR_BUCHET);
        Assert.assertNotNull(auteur);
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, auteur.getId());
        Assert.assertNotNull(auteur.getSeries());
        Assert.assertFalse(auteur.getSeries().isEmpty());
    }
}
