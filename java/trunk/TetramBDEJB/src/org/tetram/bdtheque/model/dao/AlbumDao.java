package org.tetram.bdtheque.model.dao;

import java.util.List;
import java.util.Map;

import org.tetram.bdtheque.model.entity.Album;
import org.tetram.common.model.dao.GenericDao;

public interface AlbumDao extends GenericDao<Album, String> {
	public Map<Object, List<Album>> getListAlbumByProperty(String propertyName)
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, NoSuchFieldException;
}
