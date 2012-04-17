package org.tetram.bdtheque.model.dao;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import org.hibernate.Query;
import org.hibernate.Session;
import org.tetram.bdtheque.model.entity.Album;
import org.tetram.common.model.dao.GenericDaoImpl;

public class AlbumDaoImpl extends GenericDaoImpl<Album, String> implements
		AlbumDao {

	public AlbumDaoImpl(EntityManager manager) {
		this.session = (Session) manager.getDelegate();
	}


}
