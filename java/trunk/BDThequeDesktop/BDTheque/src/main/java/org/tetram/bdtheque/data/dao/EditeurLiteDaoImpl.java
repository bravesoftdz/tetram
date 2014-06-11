package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.tetram.bdtheque.data.bean.EditeurLite;

import java.util.UUID;

/**
 * Created by Thierry on 11/06/2014.
 */
@Repository
@Lazy
public class EditeurLiteDaoImpl extends DaoROImpl<EditeurLite, UUID> implements EditeurLiteDao {
}
