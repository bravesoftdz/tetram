package org.tetram.bdtheque.model.dao;

import javax.persistence.EntityManager;

public interface BDthequeDaoFactory {
	public EntityManager getManager();
	
	public AlbumDao getAlbumDao();

}
