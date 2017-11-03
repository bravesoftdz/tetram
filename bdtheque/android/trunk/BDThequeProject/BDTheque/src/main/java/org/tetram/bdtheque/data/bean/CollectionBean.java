package org.tetram.bdtheque.data.bean;

import org.tetram.bdtheque.data.bean.lite.CollectionLiteBean;
import org.tetram.bdtheque.data.orm.annotations.Entity;
import org.tetram.bdtheque.database.DDLConstants;


@SuppressWarnings("UnusedDeclaration")
@Entity(tableName = DDLConstants.COLLECTIONS_TABLENAME)
public class CollectionBean extends CollectionLiteBean {
}
