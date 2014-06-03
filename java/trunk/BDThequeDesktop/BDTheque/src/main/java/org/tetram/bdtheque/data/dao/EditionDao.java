package org.tetram.bdtheque.data.dao;

import org.springframework.context.annotation.Configuration;
import org.tetram.bdtheque.data.bean.Edition;

import java.util.UUID;

/**
 * Created by Thierry on 03/06/2014.
 */
@Configuration
public class EditionDao extends AbstractDao<Edition, UUID> {
}
