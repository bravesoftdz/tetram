package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Couvertures.
 * @see org.tetram.reveng.Couvertures
 * @author Hibernate Tools
 */
@Stateless
public class CouverturesHome {

	private static final Log log = LogFactory.getLog(CouverturesHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Couvertures transientInstance) {
		log.debug("persisting Couvertures instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Couvertures persistentInstance) {
		log.debug("removing Couvertures instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Couvertures merge(Couvertures detachedInstance) {
		log.debug("merging Couvertures instance");
		try {
			Couvertures result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Couvertures findById(String id) {
		log.debug("getting Couvertures instance with id: " + id);
		try {
			Couvertures instance = entityManager.find(Couvertures.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
