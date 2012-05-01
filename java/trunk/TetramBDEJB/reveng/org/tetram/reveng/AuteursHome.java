package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class Auteurs.
 * @see org.tetram.reveng.Auteurs
 * @author Hibernate Tools
 */
@Stateless
public class AuteursHome {

	private static final Log log = LogFactory.getLog(AuteursHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(Auteurs transientInstance) {
		log.debug("persisting Auteurs instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(Auteurs persistentInstance) {
		log.debug("removing Auteurs instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public Auteurs merge(Auteurs detachedInstance) {
		log.debug("merging Auteurs instance");
		try {
			Auteurs result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public Auteurs findById(AuteursId id) {
		log.debug("getting Auteurs instance with id: " + id);
		try {
			Auteurs instance = entityManager.find(Auteurs.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
