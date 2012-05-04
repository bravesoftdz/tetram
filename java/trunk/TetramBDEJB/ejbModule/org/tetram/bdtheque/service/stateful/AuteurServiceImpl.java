package org.tetram.bdtheque.service.stateful;

import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateful;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.PersistenceContextType;

import org.tetram.bdtheque.common.ejb.FactoryOfDaoFactories;
import org.tetram.bdtheque.model.dao.AuteurDao;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.entity.Auteur;
import org.tetram.bdtheque.service.local.AuteurServiceLocal;
import org.tetram.bdtheque.service.remote.AuteurServiceRemote;

@Stateful(name = "auteurService")
public class AuteurServiceImpl implements AuteurServiceRemote,
		AuteurServiceLocal {

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

	public Map<Object, List<Auteur>> getListByInitiale()
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, NoSuchFieldException {
		return auteurDao.getListGroupByProperty("nom.initialeTitre",
				"initialeNom");
	}

	public List<Auteur> findAll() {
		return auteurDao.findAll();
	}

}
