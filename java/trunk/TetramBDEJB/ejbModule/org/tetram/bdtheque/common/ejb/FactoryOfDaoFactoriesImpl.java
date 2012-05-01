package org.tetram.bdtheque.common.ejb;

import javax.ejb.Stateless;
import javax.persistence.EntityManager;

import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;
import org.tetram.bdtheque.model.dao.BDthequeDaoFactoryImpl;

@Stateless(name = "factoryOfDaoFactories")
public class FactoryOfDaoFactoriesImpl implements FactoryOfDaoFactories {

  private static final long serialVersionUID = 1L;

  public BDthequeDaoFactory createBDthequeDaoFactory(EntityManager manager) {
    return new BDthequeDaoFactoryImpl(manager);
  }

}
