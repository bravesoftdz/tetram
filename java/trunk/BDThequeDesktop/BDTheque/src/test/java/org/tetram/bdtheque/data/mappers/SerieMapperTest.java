package org.tetram.bdtheque.data.mappers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Serie;
import org.tetram.bdtheque.data.bean.SerieLite;

public class SerieMapperTest extends DBTest {

    private SerieMapper mapper;

    @Override
    @Before
    public void setUp() throws Exception {
        super.setUp();
        mapper = dbSession.getMapper(SerieMapper.class);
    }

    @Test
    public void testGetSerieLiteById() throws Exception {
        SerieLite serie = mapper.getSerieLiteById(ID_SERIE_SILLAGE);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(serie);
        Assert.assertEquals(ID_SERIE_SILLAGE, serie.getId());
        Assert.assertNotNull(serie.getEditeur());
        Assert.assertEquals(ID_DELCOURT, serie.getEditeur().getId());
        Assert.assertNotNull(serie.getCollection());
        Assert.assertEquals(ID_COLLECTION_NEOPOLIS_DELCOURT, serie.getCollection().getId());
    }

    @Test
    public void testGetSerieById() throws Exception {
        Serie serie = mapper.getSerieById(ID_SERIE_SILLAGE);
        // pour le moment on suppose que si le résultat n'est pas null, c'est que tous les champs sont biens chargés
        Assert.assertNotNull(serie);
        Assert.assertEquals(ID_SERIE_SILLAGE, serie.getId());
        Assert.assertNotNull(serie.getEditeur());
        Assert.assertEquals(ID_DELCOURT, serie.getEditeur().getId());
        Assert.assertNotNull(serie.getCollection());
        Assert.assertEquals(ID_COLLECTION_NEOPOLIS_DELCOURT, serie.getCollection().getId());
        Assert.assertNotEquals("", serie.getEtat().getTexte());
        Assert.assertNotEquals("", serie.getReliure().getTexte());
        Assert.assertNotEquals("", serie.getFormatEdition().getTexte());
        Assert.assertNotEquals("", serie.getTypeEdition().getTexte());
        Assert.assertNotEquals("", serie.getOrientation().getTexte());
        Assert.assertNotEquals("", serie.getSensLecture().getTexte());
        Assert.assertNotNull(serie.getGenres());
        Assert.assertEquals(ID_GENRE_AVENTURES, serie.getGenres().get(0).getId());
        Assert.assertNotNull(serie.getAuteurs());
        Assert.assertFalse(serie.getAuteurs().isEmpty());
        Assert.assertEquals(serie.getAuteurs().size(), serie.getScenaristes().size() + serie.getDessinateurs().size() + serie.getColoristes().size());
    }
}