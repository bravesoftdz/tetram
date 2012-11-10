package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.793+0100")
@StaticMetamodel(AuteursSeries.class)
public class AuteursSeries_ {
	public static volatile SingularAttribute<AuteursSeries, AuteursSeriesId> id;
	public static volatile SingularAttribute<AuteursSeries, Series> series;
	public static volatile SingularAttribute<AuteursSeries, Personnes> personnes;
	public static volatile SingularAttribute<AuteursSeries, String> idAuteurSeries;
	public static volatile SingularAttribute<AuteursSeries, Date> dcAuteursSeries;
	public static volatile SingularAttribute<AuteursSeries, Date> dmAuteursSeries;
}
