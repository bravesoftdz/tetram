package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class CotesParabd.
 * @see org.tetram.reveng.CotesParabd
 * @author Hibernate Tools
 */
@Stateless
public class CotesParabdHome {

	private static final Log log = LogFactory.getLog(CotesParabdHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(CotesParabd transientInstance) {
		log.debug("persisting CotesParabd instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(CotesParabd persistentInstance) {
		log.debug("removing CotesParabd instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public CotesParabd merge(CotesParabd detachedInstance) {
		log.debug("merging CotesParabd instance");
		try {
			CotesParabd result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public CotesParabd findById(CotesParabdId id) {
		log.debug("getting CotesParabd instance with id: " + id);
		try {
			CotesParabd instance = entityManager.find(CotesParabd.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
