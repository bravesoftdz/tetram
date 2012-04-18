package org.tetram.bdtheque.common.ejb;

import javax.ejb.Local;
import javax.persistence.EntityManager;

import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;

@Local
public interface FactoryOfDaoFactories {
  BDthequeDaoFactory createBDthequeDaoFactory(EntityManager manager);
}
