package org.tetram.common.model.dao;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;

public class GenericDaoImpl<T, ID extends Serializable> implements
		GenericDao<T, ID> {

	protected Session session = null;

	private Class<T> persistentClass;

	@SuppressWarnings("unchecked")
	public GenericDaoImpl() {
		this.persistentClass = (Class<T>) ((ParameterizedType) getClass()
				.getGenericSuperclass()).getActualTypeArguments()[0];
	}

	@SuppressWarnings("unchecked")
	public T findById(ID id) {
		T entity = (T) getSession().load(persistentClass, id);

		return entity;
	}

	public List<T> findAll() {
		return findByCriteria();
	}

	public T makePersistent(T entity) {
		getSession().saveOrUpdate(entity);
		return entity;
	}

	public void makeTransient(T entity) {
		getSession().delete(entity);
	}

	public void refresh(T entity) {
		this.session.flush();
		this.session.refresh(entity);
	}

	@SuppressWarnings("unchecked")
	protected List<T> findByCriteria(Criterion... criterion) {
		Criteria criteria = getSession().createCriteria(persistentClass);
		for (Criterion c : criterion) {
			criteria.add(c);
		}
		return criteria.list();
	}

	@SuppressWarnings("unchecked")
	protected List<T> findByCriteria(DetachedCriteria criteria) {
		return criteria.getExecutableCriteria(getSession()).list();
	}

	public Session getSession() {
		return session;
	}

	public void setSession(Session session) {
		this.session = session;
	}

	@SuppressWarnings("unchecked")
	public Map<Object, List<T>> getListGroupByProperty(String propertyName)
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, NoSuchFieldException {
		StringBuffer queryString = new StringBuffer();
		Query query;

		queryString.append("from " + persistentClass.getName());
		queryString.append("order by " + propertyName);

		query = session.createQuery(queryString.toString());
		Iterator<?> it = query.iterate();

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
