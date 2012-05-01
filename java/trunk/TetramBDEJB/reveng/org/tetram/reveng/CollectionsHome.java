package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Collections.
 * @see org.tetram.reveng.Collections
 * @author Hibernate Tools
 */
@Stateless
public class CollectionsHome {

	private static final Log log = LogFactory.getLog(CollectionsHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Collections transientInstance) {
		log.debug("persisting Collections instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Collections persistentInstance) {
		log.debug("removing Collections instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Collections merge(Collections detachedInstance) {
		log.debug("merging Collections instance");
		try {
			Collections result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Collections findById(String id) {
		log.debug("getting Collections instance with id: " + id);
		try {
			Collections instance = entityManager.find(Collections.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
