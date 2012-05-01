package org.tetram.bdtheque.service.local;

import java.util.List;
import java.util.Map;

import javax.ejb.Local;

import org.tetram.bdtheque.model.entity.Auteur;

@Local
public interface AuteurServiceLocal {
	public Map<Object, List<Auteur>> getListByInitiale()
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, NoSuchFieldException;
}
