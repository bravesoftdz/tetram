package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.886+0100")
@StaticMetamodel(ConversionsId.class)
public class ConversionsId_ {
	public static volatile SingularAttribute<ConversionsId, String> idConversion;
	public static volatile SingularAttribute<ConversionsId, BigDecimal> taux;
	public static volatile SingularAttribute<ConversionsId, Date> dcConversions;
	public static volatile SingularAttribute<ConversionsId, Date> dmConversions;
	public static volatile SingularAttribute<ConversionsId, String> monnaie1;
	public static volatile SingularAttribute<ConversionsId, String> monnaie2;
}
