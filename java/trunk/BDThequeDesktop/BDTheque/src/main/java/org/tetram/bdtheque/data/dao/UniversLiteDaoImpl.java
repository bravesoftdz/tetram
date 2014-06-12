package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Repository;
import org.tetram.bdtheque.data.bean.UniversLite;

import java.util.UUID;

/**
 * Created by Thierry on 12/06/2014.
 */
@Repository
@Lazy
public class UniversLiteDaoImpl extends DaoROImpl<UniversLite, UUID> implements UniversLiteDao {
}
