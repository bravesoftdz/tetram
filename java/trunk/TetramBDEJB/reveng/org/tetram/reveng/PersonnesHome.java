package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Personnes.
 * @see org.tetram.reveng.Personnes
 * @author Hibernate Tools
 */
@Stateless
public class PersonnesHome {

	private static final Log log = LogFactory.getLog(PersonnesHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Personnes transientInstance) {
		log.debug("persisting Personnes instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Personnes persistentInstance) {
		log.debug("removing Personnes instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Personnes merge(Personnes detachedInstance) {
		log.debug("merging Personnes instance");
		try {
			Personnes result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Personnes findById(String id) {
		log.debug("getting Personnes instance with id: " + id);
		try {
			Personnes instance = entityManager.find(Personnes.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
