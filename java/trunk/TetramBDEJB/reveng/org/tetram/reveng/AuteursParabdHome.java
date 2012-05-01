package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class AuteursParabd.
 * @see org.tetram.reveng.AuteursParabd
 * @author Hibernate Tools
 */
@Stateless
public class AuteursParabdHome {

	private static final Log log = LogFactory.getLog(AuteursParabdHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(AuteursParabd transientInstance) {
		log.debug("persisting AuteursParabd instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(AuteursParabd persistentInstance) {
		log.debug("removing AuteursParabd instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public AuteursParabd merge(AuteursParabd detachedInstance) {
		log.debug("merging AuteursParabd instance");
		try {
			AuteursParabd result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public AuteursParabd findById(AuteursParabdId id) {
		log.debug("getting AuteursParabd instance with id: " + id);
		try {
			AuteursParabd instance = entityManager
					.find(AuteursParabd.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
