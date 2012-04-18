package org.tetram.bdtheque.model.dao;

import javax.persistence.EntityManager;

public class BDthequeDaoFactoryImpl implements BDthequeDaoFactory {

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
