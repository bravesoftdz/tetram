package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Collection;
import org.tetram.bdtheque.data.bean.CollectionLite;

import java.util.List;

public class CollectionMapperTest extends DBTest {

    protected CollectionMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(CollectionMapper.class);
    }

    @Test
    public void testGetCollectionLiteById() throws Exception {
        CollectionLite collectionLite = mapper.getCollectionLiteById(ID_COLLECTION_GENERATION_COMICS_PANINI);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collectionLite);
        Assert.assertEquals(ID_COLLECTION_GENERATION_COMICS_PANINI, collectionLite.getId());
    }

    @Test
    public void testGetListCollectionLiteByEditeurId() throws Exception {
        List<CollectionLite> lstCollectionLite = mapper.getListCollectionLiteByEditeurId(ID_EDITEUR_GLENAT);
        Assert.assertFalse(lstCollectionLite.isEmpty());
        Assert.assertNotNull(lstCollectionLite.get(0).getId());
    }

    @Test
    public void testGetCollectionById() throws Exception {
        Collection collection = mapper.getCollectionById(ID_COLLECTION_GENERATION_COMICS_PANINI);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(collection);
        Assert.assertEquals(ID_COLLECTION_GENERATION_COMICS_PANINI, collection.getId());
    }
}