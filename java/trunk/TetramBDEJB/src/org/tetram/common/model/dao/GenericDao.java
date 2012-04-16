package org.tetram.common.model.dao;

import java.io.Serializable;
import java.util.List;

public interface GenericDao<T, ID extends Serializable> {
	
	public T findById(ID id);

	public List<T> findAll();

	public T makePersistent(T entity);

	public void makeTransient(T entity);

	public void refresh(T entity);

}
