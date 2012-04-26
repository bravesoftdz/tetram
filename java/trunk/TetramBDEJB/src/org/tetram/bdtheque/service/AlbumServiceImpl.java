package org.tetram.bdtheque.service;

import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.tetram.bdtheque.common.ejb.FactoryOfDaoFactories;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.entity.Album;

@Stateless(name = "albumService")
public class AlbumServiceImpl implements AlbumService {

  @EJB
  private FactoryOfDaoFactories daoFactories;

  private BDthequeDaoFactory bdthequeDaoFactory;

  @PersistenceContext
  private EntityManager manager;

  @PostConstruct
  public void init() {
    this.bdthequeDaoFactory = this.daoFactories.createBDthequeDaoFactory(this.manager);
  }

  public Map<Object, List<Album>> getListByAnnee()
      throws IllegalArgumentException,
        SecurityException,
        IllegalAccessException,
        NoSuchFieldException {
    return bdthequeDaoFactory.getAlbumDao().getListGroupByProperty("anneeParution");
  }

  public Map<Object, List<Album>> getListByInitiale()
      throws IllegalArgumentException,
        SecurityException,
        IllegalAccessException,
        NoSuchFieldException {
    return bdthequeDaoFactory.getAlbumDao().getListGroupByProperty("initialeTitre");
  }

  public String test() {
    // TODO Auto-generated method stub
    return new String("ceci est un test");
  }

  @Override
  public BDthequeDaoFactory getbdthequeDaoFactory() {
    return bdthequeDaoFactory;
  }

}
