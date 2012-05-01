package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Albums.
 * @see org.tetram.reveng.Albums
 * @author Hibernate Tools
 */
@Stateless
public class AlbumsHome {

	private static final Log log = LogFactory.getLog(AlbumsHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Albums transientInstance) {
		log.debug("persisting Albums instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Albums persistentInstance) {
		log.debug("removing Albums instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Albums merge(Albums detachedInstance) {
		log.debug("merging Albums instance");
		try {
			Albums result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Albums findById(String id) {
		log.debug("getting Albums instance with id: " + id);
		try {
			Albums instance = entityManager.find(Albums.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
