package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.840+0100")
@StaticMetamodel(Collections.class)
public class Collections_ {
	public static volatile SingularAttribute<Collections, String> idCollection;
	public static volatile SingularAttribute<Collections, Editeurs> editeurs;
	public static volatile SingularAttribute<Collections, Character> initialenomcollection;
	public static volatile SingularAttribute<Collections, Date> dcCollections;
	public static volatile SingularAttribute<Collections, Date> dmCollections;
	public static volatile SingularAttribute<Collections, String> nomcollection;
}
