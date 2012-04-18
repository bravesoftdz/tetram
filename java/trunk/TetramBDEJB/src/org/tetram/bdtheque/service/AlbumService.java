package org.tetram.bdtheque.service;

import java.util.List;
import java.util.Map;

import javax.ejb.Local;

import org.tetram.bdtheque.model.entity.Album;

@Local
public interface AlbumService {
  public Map<Object, List<Album>> getListByAnnee()
      throws IllegalArgumentException,
        SecurityException,
        IllegalAccessException,
        NoSuchFieldException;

  public Map<Object, List<Album>> getListByInitiale()
      throws IllegalArgumentException,
        SecurityException,
        IllegalAccessException,
        NoSuchFieldException;
}
