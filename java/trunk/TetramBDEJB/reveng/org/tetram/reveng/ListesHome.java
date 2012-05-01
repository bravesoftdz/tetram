package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Listes.
 * @see org.tetram.reveng.Listes
 * @author Hibernate Tools
 */
@Stateless
public class ListesHome {

	private static final Log log = LogFactory.getLog(ListesHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Listes transientInstance) {
		log.debug("persisting Listes instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Listes persistentInstance) {
		log.debug("removing Listes instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Listes merge(Listes detachedInstance) {
		log.debug("merging Listes instance");
		try {
			Listes result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Listes findById(ListesId id) {
		log.debug("getting Listes instance with id: " + id);
		try {
			Listes instance = entityManager.find(Listes.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
