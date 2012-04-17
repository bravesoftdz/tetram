package org.tetram.bdtheque.model.dao;

import javax.persistence.EntityManager;

import org.hibernate.Session;
import org.tetram.bdtheque.model.entity.Album;
import org.tetram.common.model.dao.GenericDaoImpl;

public class AlbumDaoImpl extends GenericDaoImpl<Album, String> implements
		AlbumDao {

	public AlbumDaoImpl(EntityManager manager) {
		this.session = (Session) manager.getDelegate();
	}


}
