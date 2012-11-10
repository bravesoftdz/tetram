package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.167+0100")
@StaticMetamodel(Genreseries.class)
public class Genreseries_ {
	public static volatile SingularAttribute<Genreseries, GenreseriesId> id;
	public static volatile SingularAttribute<Genreseries, Series> series;
	public static volatile SingularAttribute<Genreseries, Genres> genres;
	public static volatile SingularAttribute<Genreseries, String> idGenreseries;
	public static volatile SingularAttribute<Genreseries, Date> dcGenreseries;
	public static volatile SingularAttribute<Genreseries, Date> dmGenreseries;
}
