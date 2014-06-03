package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Configuration;
import org.tetram.bdtheque.data.bean.Collection;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Configuration
public class CollectionDao extends AbstractDao<Collection, UUID> {
}
