package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Cotes.
 * @see org.tetram.reveng.Cotes
 * @author Hibernate Tools
 */
@Stateless
public class CotesHome {

	private static final Log log = LogFactory.getLog(CotesHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Cotes transientInstance) {
		log.debug("persisting Cotes instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Cotes persistentInstance) {
		log.debug("removing Cotes instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Cotes merge(Cotes detachedInstance) {
		log.debug("merging Cotes instance");
		try {
			Cotes result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Cotes findById(CotesId id) {
		log.debug("getting Cotes instance with id: " + id);
		try {
			Cotes instance = entityManager.find(Cotes.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
