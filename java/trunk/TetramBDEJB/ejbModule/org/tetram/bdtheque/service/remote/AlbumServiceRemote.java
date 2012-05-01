package org.tetram.bdtheque.service.remote;

import javax.ejb.Remote;

import org.tetram.bdtheque.model.entity.Album;

@Remote
public interface AlbumServiceRemote {
	public String test();

	public Album getAlbum(String id);

}
