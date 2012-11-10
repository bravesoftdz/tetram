package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.136+0100")
@StaticMetamodel(Genres.class)
public class Genres_ {
	public static volatile SingularAttribute<Genres, String> idGenre;
	public static volatile SingularAttribute<Genres, Date> dcGenres;
	public static volatile SingularAttribute<Genres, Date> dmGenres;
	public static volatile SingularAttribute<Genres, Character> initialegenre;
	public static volatile SingularAttribute<Genres, String> genre;
	public static volatile SingularAttribute<Genres, String> test;
	public static volatile SetAttribute<Genres, Genreseries> genreserieses;
}
