package org.tetram.reveng;

// Generated 1 mai 2012 09:52:06 by Hibernate Tools 3.4.0.CR1

import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Home object for domain model class ImportAssociations.
 * @see org.tetram.reveng.ImportAssociations
 * @author Hibernate Tools
 */
@Stateless
public class ImportAssociationsHome {

	private static final Log log = LogFactory
			.getLog(ImportAssociationsHome.class);

	@PersistenceContext
	private EntityManager entityManager;

	public void persist(ImportAssociations transientInstance) {
		log.debug("persisting ImportAssociations instance");
		try {
			entityManager.persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void remove(ImportAssociations persistentInstance) {
		log.debug("removing ImportAssociations instance");
		try {
			entityManager.remove(persistentInstance);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public ImportAssociations merge(ImportAssociations detachedInstance) {
		log.debug("merging ImportAssociations instance");
		try {
			ImportAssociations result = entityManager.merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ImportAssociations findById(ImportAssociationsId id) {
		log.debug("getting ImportAssociations instance with id: " + id);
		try {
			ImportAssociations instance = entityManager.find(
					ImportAssociations.class, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}
}
