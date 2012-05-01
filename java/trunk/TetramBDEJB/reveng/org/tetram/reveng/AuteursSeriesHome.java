package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class AuteursSeries.
 * @see org.tetram.reveng.AuteursSeries
 * @author Hibernate Tools
 */
@Stateless
public class AuteursSeriesHome {

	private static final Log log = LogFactory.getLog(AuteursSeriesHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(AuteursSeries transientInstance) {
		log.debug("persisting AuteursSeries instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(AuteursSeries persistentInstance) {
		log.debug("removing AuteursSeries instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public AuteursSeries merge(AuteursSeries detachedInstance) {
		log.debug("merging AuteursSeries instance");
		try {
			AuteursSeries result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public AuteursSeries findById(AuteursSeriesId id) {
		log.debug("getting AuteursSeries instance with id: " + id);
		try {
			AuteursSeries instance = entityManager
					.find(AuteursSeries.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
