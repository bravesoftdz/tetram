package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.949+0100")
@StaticMetamodel(CotesParabd.class)
public class CotesParabd_ {
	public static volatile SingularAttribute<CotesParabd, CotesParabdId> id;
	public static volatile SingularAttribute<CotesParabd, Parabd> parabd;
	public static volatile SingularAttribute<CotesParabd, String> idCoteParabd;
	public static volatile SingularAttribute<CotesParabd, BigDecimal> prixcote;
	public static volatile SingularAttribute<CotesParabd, Date> dcCotesParabd;
	public static volatile SingularAttribute<CotesParabd, Date> dmCotesParabd;
}
