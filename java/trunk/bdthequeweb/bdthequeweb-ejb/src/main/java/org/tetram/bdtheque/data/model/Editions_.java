package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.089+0100")
@StaticMetamodel(Editions.class)
public class Editions_ {
	public static volatile SingularAttribute<Editions, String> idEdition;
	public static volatile SingularAttribute<Editions, Editeurs> editeurs;
	public static volatile SingularAttribute<Editions, Albums> albums;
	public static volatile SingularAttribute<Editions, String> idCollection;
	public static volatile SingularAttribute<Editions, Short> anneeedition;
	public static volatile SingularAttribute<Editions, BigDecimal> prix;
	public static volatile SingularAttribute<Editions, Short> vo;
	public static volatile SingularAttribute<Editions, Short> couleur;
	public static volatile SingularAttribute<Editions, Short> prete;
	public static volatile SingularAttribute<Editions, Short> stock;
	public static volatile SingularAttribute<Editions, Short> dedicace;
	public static volatile SingularAttribute<Editions, Date> dateachat;
	public static volatile SingularAttribute<Editions, Short> gratuit;
	public static volatile SingularAttribute<Editions, Short> offert;
	public static volatile SingularAttribute<Editions, Integer> nombredepages;
	public static volatile SingularAttribute<Editions, Short> anneecote;
	public static volatile SingularAttribute<Editions, BigDecimal> prixcote;
	public static volatile SingularAttribute<Editions, Date> dcEditions;
	public static volatile SingularAttribute<Editions, Date> dmEditions;
	public static volatile SingularAttribute<Editions, String> isbn;
	public static volatile SingularAttribute<Editions, String> numeroperso;
	public static volatile SingularAttribute<Editions, String> notes;
	public static volatile SingularAttribute<Editions, String> etat;
	public static volatile SingularAttribute<Editions, String> reliure;
	public static volatile SingularAttribute<Editions, String> typeedition;
	public static volatile SingularAttribute<Editions, String> orientation;
	public static volatile SingularAttribute<Editions, String> formatedition;
	public static volatile SingularAttribute<Editions, String> senslecture;
	public static volatile SetAttribute<Editions, Statut> statuts;
	public static volatile SetAttribute<Editions, Cotes> coteses;
}
