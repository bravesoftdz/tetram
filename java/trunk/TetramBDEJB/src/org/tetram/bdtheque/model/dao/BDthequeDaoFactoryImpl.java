package org.tetram.bdtheque.model.dao;

import javax.persistence.EntityManager;

public class BDthequeDaoFactoryImpl implements BDthequeDaoFactory {

  private static final long serialVersionUID = 1L;
  
  private EntityManager manager;

  public BDthequeDaoFactoryImpl(EntityManager manager) {
    this.manager = manager;
  }

  public EntityManager getManager() {
    return this.manager;
  }

  public AlbumDao getAlbumDao() {
    return new AlbumDaoImpl(manager);
  }

}
