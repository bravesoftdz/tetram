package org.tetram.bdtheque.model.dao;

import javax.persistence.EntityManager;

import org.hibernate.Session;
import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.common.model.dao.GenericHibernateDaoImpl;

public class AuteurDaoImpl extends GenericHibernateDaoImpl<Auteur, String>
		implements AuteurDao {

	public AuteurDaoImpl(EntityManager manager) {
		this.session = (Session) manager.getDelegate();
	}

}
