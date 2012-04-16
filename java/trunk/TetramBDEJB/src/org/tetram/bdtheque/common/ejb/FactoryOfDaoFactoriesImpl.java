package org.tetram.bdtheque.common.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;

import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactoryImpl;

@Stateless(name = "factoryOfDaoFactories")
public class FactoryOfDaoFactoriesImpl implements FactoryOfDaoFactories {

	public BDthequeDaoFactory createBDthequeDaoFactory(EntityManager manager) {
		return new BDthequeDaoFactoryImpl(manager);
	}

}
