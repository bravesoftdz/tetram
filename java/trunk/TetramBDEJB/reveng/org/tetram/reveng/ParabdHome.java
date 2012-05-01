package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Parabd.
 * @see org.tetram.reveng.Parabd
 * @author Hibernate Tools
 */
@Stateless
public class ParabdHome {

	private static final Log log = LogFactory.getLog(ParabdHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Parabd transientInstance) {
		log.debug("persisting Parabd instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Parabd persistentInstance) {
		log.debug("removing Parabd instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Parabd merge(Parabd detachedInstance) {
		log.debug("merging Parabd instance");
		try {
			Parabd result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Parabd findById(String id) {
		log.debug("getting Parabd instance with id: " + id);
		try {
			Parabd instance = entityManager.find(Parabd.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
