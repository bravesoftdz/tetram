package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.479+0100")
@StaticMetamodel(Series.class)
public class Series_ {
	public static volatile SingularAttribute<Series, String> idSerie;
	public static volatile SingularAttribute<Series, String> idEditeur;
	public static volatile SingularAttribute<Series, String> idCollection;
	public static volatile SingularAttribute<Series, Short> terminee;
	public static volatile SingularAttribute<Series, Short> complete;
	public static volatile SingularAttribute<Series, Short> suivremanquants;
	public static volatile SingularAttribute<Series, Short> suivresorties;
	public static volatile SingularAttribute<Series, Character> initialetitreserie;
	public static volatile SingularAttribute<Series, Date> dcSeries;
	public static volatile SingularAttribute<Series, Date> dmSeries;
	public static volatile SingularAttribute<Series, Integer> nbAlbums;
	public static volatile SingularAttribute<Series, Short> vo;
	public static volatile SingularAttribute<Series, Short> couleur;
	public static volatile SingularAttribute<Series, String> titreserie;
	public static volatile SingularAttribute<Series, String> soundextitreserie;
	public static volatile SingularAttribute<Series, Short> notation;
	public static volatile SingularAttribute<Series, String> siteweb;
	public static volatile SingularAttribute<Series, String> sujetserie;
	public static volatile SingularAttribute<Series, String> remarquesserie;
	public static volatile SingularAttribute<Series, String> etat;
	public static volatile SingularAttribute<Series, String> reliure;
	public static volatile SingularAttribute<Series, String> typeedition;
	public static volatile SingularAttribute<Series, String> orientation;
	public static volatile SingularAttribute<Series, String> formatedition;
	public static volatile SingularAttribute<Series, String> senslecture;
	public static volatile SetAttribute<Series, AuteursSeries> auteursSerieses;
	public static volatile SetAttribute<Series, Genreseries> genreserieses;
}
