package org.tetram.bdtheque.data.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.tetram.bdtheque.data.bean.PersonneLite;
import org.tetram.bdtheque.data.dao.mappers.AuteurMapper;
import org.tetram.bdtheque.gui.utils.InitialeEntity;

import java.util.List;
import java.util.UUID;

/**
 * Created by Thierry on 13/06/2014.
 */
@Repository
@Lazy
@Transactional
@SuppressWarnings("UnusedDeclaration")
public class PersonneLiteDaoImpl extends DaoROImpl<PersonneLite, UUID> implements PersonneLiteDao {

    @Autowired
    private AuteurMapper auteurMapper;

    @Override
    public List<InitialeEntity<Character>> getListInitiales(String filtre) {
        return auteurMapper.getInitiales(filtre);
    }

    @Override
    public List<PersonneLite> getListEntitiesByInitiale(InitialeEntity<Character> initiale, String filtre) {
        return auteurMapper.getPersonneLiteByInitiale(initiale.getValue(), filtre);
    }
}
