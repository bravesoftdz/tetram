package org.tetram.bdtheque.data.dao;

import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.Auteur;

import java.util.UUID;

/**
 * Created by Thierry on 10/06/2014.
 */
@Transactional(propagation = Propagation.REQUIRED)
public interface AuteurDao extends DaoRW<Auteur, UUID> {

}
