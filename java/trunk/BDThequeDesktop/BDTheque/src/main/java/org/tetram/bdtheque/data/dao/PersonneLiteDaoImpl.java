package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.tetram.bdtheque.data.bean.PersonneLite;

import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
public class PersonneLiteDaoImpl extends DaoROImpl<PersonneLite, UUID> implements PersonneLiteDao {
}
