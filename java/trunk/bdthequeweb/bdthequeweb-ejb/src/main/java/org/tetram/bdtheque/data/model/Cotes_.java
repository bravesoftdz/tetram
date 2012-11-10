package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.902+0100")
@StaticMetamodel(Cotes.class)
public class Cotes_ {
	public static volatile SingularAttribute<Cotes, CotesId> id;
	public static volatile SingularAttribute<Cotes, Editions> editions;
	public static volatile SingularAttribute<Cotes, String> idCote;
	public static volatile SingularAttribute<Cotes, BigDecimal> prixcote;
	public static volatile SingularAttribute<Cotes, Date> dcCotes;
	public static volatile SingularAttribute<Cotes, Date> dmCotes;
}
