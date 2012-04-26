package org.tetram.bdtheque.common.ejb;

import java.io.Serializable;

import javax.ejb.Remote;
import javax.persistence.EntityManager;

import org.tetram.bdtheque.model.dao.BDthequeDaoFactory;

@Remote
public interface FactoryOfDaoFactories extends Serializable {
  public BDthequeDaoFactory createBDthequeDaoFactory(EntityManager manager);
}
