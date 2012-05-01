package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Genres.
 * @see org.tetram.reveng.Genres
 * @author Hibernate Tools
 */
@Stateless
public class GenresHome {

	private static final Log log = LogFactory.getLog(GenresHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Genres transientInstance) {
		log.debug("persisting Genres instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Genres persistentInstance) {
		log.debug("removing Genres instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Genres merge(Genres detachedInstance) {
		log.debug("merging Genres instance");
		try {
			Genres result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Genres findById(String id) {
		log.debug("getting Genres instance with id: " + id);
		try {
			Genres instance = entityManager.find(Genres.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
