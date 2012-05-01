package org.tetram.bdtheque.service.remote;

import javax.ejb.Remote;

import org.tetram.bdtheque.model.entity.Auteur;

@Remote
public interface AuteurServiceRemote {
	public Auteur getAuteur(String id);

}
