package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.dao.CollectionDao;
import org.tetram.bdtheque.data.factories.CollectionFactory;
import org.tetram.bdtheque.data.orm.annotations.BeanDaoClass;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.database.DDLConstants;


@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.COLLECTIONS_TABLENAME, factoryClass = CollectionFactory.class)
@BeanDaoClass(CollectionDao.class)
public class CollectionBean extends CollectionLiteBean {
}
