package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Editions.
 * @see org.tetram.reveng.Editions
 * @author Hibernate Tools
 */
@Stateless
public class EditionsHome {

	private static final Log log = LogFactory.getLog(EditionsHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Editions transientInstance) {
		log.debug("persisting Editions instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Editions persistentInstance) {
		log.debug("removing Editions instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Editions merge(Editions detachedInstance) {
		log.debug("merging Editions instance");
		try {
			Editions result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Editions findById(String id) {
		log.debug("getting Editions instance with id: " + id);
		try {
			Editions instance = entityManager.find(Editions.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
