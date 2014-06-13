package org.tetram.bdtheque.data.dao;

import org.junit.Assert;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.tetram.bdtheque.data.Constants;
import org.tetram.bdtheque.data.DBTest;
import org.tetram.bdtheque.data.bean.Serie;

public class SerieDaoImplTest extends DBTest {

    @Autowired
    SerieDao serieDao;
    @Autowired
    EditeurDao editeurDao;
    @Autowired
    PersonneLiteDao personneLiteDao;
    @Autowired
    UniversLiteDao universLiteDao;
    @Autowired
    GenreLiteDao genreLiteDao;

    @Test
    public void testSave() throws Exception {
        Serie serie = new Serie();
        serie.setTitreSerie(Constants.TEST_CREATE);
        serie.setEditeur(editeurDao.get(Constants.ID_EDITEUR_DELCOURT));
        serie.addGenre(genreLiteDao.get(Constants.ID_GENRE_AVENTURES));
        serie.addScenariste(personneLiteDao.get(Constants.ID_AUTEUR_BUCHET));
        serie.addUnivers(universLiteDao.get(Constants.ID_UNIVERS_TROLLS_DE_TROY));
        serieDao.save(serie);
        Assert.assertNotNull(serie.getId());

        serie = serieDao.get(serie.getId());
        Assert.assertNotNull(serie);

        Assert.assertNotNull(serie.getAuteurs());
        Assert.assertEquals(1, serie.getAuteurs().size());
        Assert.assertNotNull(serie.getScenaristes());
        Assert.assertEquals(1, serie.getScenaristes().size());
        Assert.assertEquals(Constants.ID_AUTEUR_BUCHET, serie.getScenaristes().iterator().next().getPersonne().getId());

        Assert.assertNotNull(serie.getUnivers());
        Assert.assertEquals(1, serie.getUnivers().size());
        Assert.assertEquals(Constants.ID_UNIVERS_TROLLS_DE_TROY, serie.getUnivers().iterator().next().getId());

        Assert.assertNotNull(serie.getGenres());
        Assert.assertEquals(1, serie.getGenres().size());
        Assert.assertEquals(Constants.ID_GENRE_AVENTURES, serie.getGenres().iterator().next().getId());

        serieDao.delete(serie.getId());
        serie = serieDao.get(serie.getId());
        Assert.assertNull(serie);
    }
}