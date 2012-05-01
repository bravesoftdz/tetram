package org.tetram.bdtheque.service.stateless;

import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.tetram.bdtheque.common.ejb.FactoryOfDaoFactories;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.entity.Album;
import org.tetram.bdtheque.service.local.AlbumServiceLocal;
import org.tetram.bdtheque.service.remote.AlbumServiceRemote;

@Stateless(mappedName = "albumService")
public class AlbumServiceImpl implements AlbumServiceRemote, AlbumServiceLocal {

	@EJB
	private FactoryOfDaoFactories daoFactories;

	private BDthequeDaoFactory bdthequeDaoFactory;

	@PersistenceContext
	private EntityManager manager;

	@PostConstruct
	public void init() {
		this.bdthequeDaoFactory = this.daoFactories
				.createBDthequeDaoFactory(this.manager);
	}

	public Map<Object, List<Album>> getListByAnnee() {
		return bdthequeDaoFactory.getAlbumDao().getListGroupByProperty(
				"anneeParution");
	}

	public Map<Object, List<Album>> getListByInitiale() {
		return bdthequeDaoFactory.getAlbumDao().getListGroupByProperty(
				"initialeTitre");
	}

	public String test() {
		return new String("ceci est un test");
	}

	public BDthequeDaoFactory getbdthequeDaoFactory() {
		return bdthequeDaoFactory;
	}

	public Album getAlbum(String id) {
		return bdthequeDaoFactory.getAlbumDao().findById(id);
	}

}
