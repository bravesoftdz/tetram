package org.tetram.bdtheque.service;

import javax.ejb.Remote;

import org.tetram.bdtheque.model.entity.Auteur;

@Remote
public interface AuteurService {
	public Auteur getAuteur(String id);

}
