package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.433+0100")
@StaticMetamodel(Parabd.class)
public class Parabd_ {
	public static volatile SingularAttribute<Parabd, String> idParabd;
	public static volatile SingularAttribute<Parabd, String> idSerie;
	public static volatile SingularAttribute<Parabd, Short> achat;
	public static volatile SingularAttribute<Parabd, Integer> complet;
	public static volatile SingularAttribute<Parabd, Short> dedicace;
	public static volatile SingularAttribute<Parabd, Short> numerote;
	public static volatile SingularAttribute<Parabd, Short> annee;
	public static volatile SingularAttribute<Parabd, Short> anneecote;
	public static volatile SingularAttribute<Parabd, BigDecimal> prixcote;
	public static volatile SingularAttribute<Parabd, Short> prete;
	public static volatile SingularAttribute<Parabd, Short> stock;
	public static volatile SingularAttribute<Parabd, Date> dateachat;
	public static volatile SingularAttribute<Parabd, BigDecimal> prix;
	public static volatile SingularAttribute<Parabd, Short> gratuit;
	public static volatile SingularAttribute<Parabd, Short> offert;
	public static volatile SingularAttribute<Parabd, Short> stockageparabd;
	public static volatile SingularAttribute<Parabd, byte[]> imageparabd;
	public static volatile SingularAttribute<Parabd, Character> initialetitreparabd;
	public static volatile SingularAttribute<Parabd, Date> dcParabd;
	public static volatile SingularAttribute<Parabd, Date> dmParabd;
	public static volatile SingularAttribute<Parabd, String> titreparabd;
	public static volatile SingularAttribute<Parabd, String> soundextitreparabd;
	public static volatile SingularAttribute<Parabd, String> fichierparabd;
	public static volatile SingularAttribute<Parabd, String> description;
	public static volatile SingularAttribute<Parabd, String> categorieparabd;
	public static volatile SetAttribute<Parabd, AuteursParabd> auteursParabds;
	public static volatile SetAttribute<Parabd, CotesParabd> cotesParabds;
}
