package org.tetram.bdtheque.service;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceContextType;

import org.tetram.bdtheque.common.ejb.FactoryOfDaoFactories;
import org.tetram.bdtheque.model.dao.AuteurDao;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.entity.Auteur;

@Stateless(name = "auteurService")
public class AuteurServiceImpl implements AuteurService {

	@EJB
	private FactoryOfDaoFactories daoFactories;

	private BDthequeDaoFactory bdthequeDaoFactory;
	private AuteurDao auteurDao;

	@PersistenceContext(type = PersistenceContextType.EXTENDED)
	private EntityManager manager;

	@PostConstruct
	public void init() {
		this.bdthequeDaoFactory = this.daoFactories
				.createBDthequeDaoFactory(this.manager);
		this.auteurDao = this.bdthequeDaoFactory.getAuteurDao(); 
	}

	public Auteur getAuteur(String id) {
		return this.auteurDao.findById(id);
	}

}
