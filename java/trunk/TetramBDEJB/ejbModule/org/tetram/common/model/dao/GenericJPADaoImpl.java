package org.tetram.common.model.dao;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.jboss.logging.Logger;

public class GenericJPADaoImpl<T, ID extends Serializable> implements
		GenericDao<T, ID> {

	private Class<T> persistentClass;
	private Logger log;

	@PersistenceContext
	private EntityManager entityManager;

	@SuppressWarnings("unchecked")
	public GenericJPADaoImpl() {
		this.persistentClass = (Class<T>) ((ParameterizedType) getClass()
				.getGenericSuperclass()).getActualTypeArguments()[0];
		this.log = Logger.getLogger(this.persistentClass.getName());
	}

	public T findById(ID id) {
		log.debug("getting " + persistentClass.getName()
				+ " instance with id: " + id);
		try {
			T instance = entityManager.find(persistentClass, id);
			log.debug("get successful");
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}

	@Override
	public List<T> findAll() {
		return null;
	}

	public T makePersistent(T entity) {
		log.debug("persisting " + persistentClass.getName() + " instance");
		try {
			entityManager.persist(entity);
			log.debug("persist successful");
			return entity;
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void makeTransient(T entity) {
		log.debug("removing " + persistentClass.getName() + " instance");
		try {
			entityManager.remove(entity);
			log.debug("remove successful");
		} catch (RuntimeException re) {
			log.error("remove failed", re);
			throw re;
		}
	}

	public void refresh(T entity) {
		log.debug("refreshing " + persistentClass.getName() + " instance");
		try {
			entityManager.refresh(entity);
			log.debug("refresh successful");
		} catch (RuntimeException re) {
			log.error("refresh failed", re);
			throw re;
		}
	}

	@SuppressWarnings("unchecked")
	public Map<Object, List<T>> getListGroupByProperty(String propertyName)
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, NoSuchFieldException {
		StringBuffer queryString = new StringBuffer();
		Query query;

		queryString.append("from " + persistentClass.getName());
		queryString.append("order by " + propertyName);

		query = entityManager.createQuery(queryString.toString());
		Iterator<?> it = query.getResultList().iterator();

		Object obj;
		Object propertyValue;
		Field propertyField = persistentClass.getField(propertyName);
		Map<Object, List<T>> result = new HashMap<Object, List<T>>();
		while (it.hasNext()) {
			obj = it.next();
			propertyValue = propertyField.get(obj);

			if (!result.containsKey(propertyValue)) {
				result.put(propertyValue, new ArrayList<T>());
			}
			result.get(propertyValue).add((T) obj);
		}

		return result;
	}

}
