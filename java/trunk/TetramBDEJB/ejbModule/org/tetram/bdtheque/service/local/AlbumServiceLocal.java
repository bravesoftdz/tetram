package org.tetram.bdtheque.service.local;

import java.util.List;
import java.util.Map;

import javax.ejb.Local;

import org.tetram.bdtheque.model.entity.Album;

@Local
public interface AlbumServiceLocal {
	public Map<Object, List<Album>> getListByAnnee();

	public Map<Object, List<Album>> getListByInitiale();
}
