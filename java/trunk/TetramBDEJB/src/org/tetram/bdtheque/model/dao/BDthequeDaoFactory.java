package org.tetram.bdtheque.model.dao;

import java.io.Serializable;

import javax.persistence.EntityManager;

public interface BDthequeDaoFactory extends Serializable {
  public EntityManager getManager();

  public AlbumDao getAlbumDao();

}
