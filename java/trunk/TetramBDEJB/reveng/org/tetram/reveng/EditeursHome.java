package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Editeurs.
 * @see org.tetram.reveng.Editeurs
 * @author Hibernate Tools
 */
@Stateless
public class EditeursHome {

	private static final Log log = LogFactory.getLog(EditeursHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Editeurs transientInstance) {
		log.debug("persisting Editeurs instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Editeurs persistentInstance) {
		log.debug("removing Editeurs instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Editeurs merge(Editeurs detachedInstance) {
		log.debug("merging Editeurs instance");
		try {
			Editeurs result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Editeurs findById(String id) {
		log.debug("getting Editeurs instance with id: " + id);
		try {
			Editeurs instance = entityManager.find(Editeurs.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
