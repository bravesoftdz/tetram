package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.dao.CollectionDao;
import org.tetram.bdtheque.data.factories.CollectionFactory;
import org.tetram.bdtheque.data.utils.BeanDaoClass;
import org.tetram.bdtheque.data.utils.Entity;
import org.tetram.bdtheque.database.DDLConstants;


@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.COLLECTIONS_TABLENAME, primaryKey = DDLConstants.COLLECTIONS_ID, factoryClass = CollectionFactory.class)
@BeanDaoClass(CollectionDao.class)
public class CollectionBean extends CollectionLiteBean {
}
