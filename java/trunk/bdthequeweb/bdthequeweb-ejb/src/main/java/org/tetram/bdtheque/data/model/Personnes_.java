package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.448+0100")
@StaticMetamodel(Personnes.class)
public class Personnes_ {
	public static volatile SingularAttribute<Personnes, String> idPersonne;
	public static volatile SingularAttribute<Personnes, Character> initialenompersonne;
	public static volatile SingularAttribute<Personnes, Date> dcPersonnes;
	public static volatile SingularAttribute<Personnes, Date> dmPersonnes;
	public static volatile SingularAttribute<Personnes, String> nompersonne;
	public static volatile SingularAttribute<Personnes, String> siteweb;
	public static volatile SingularAttribute<Personnes, String> biographie;
	public static volatile SetAttribute<Personnes, AuteursParabd> auteursParabds;
	public static volatile SetAttribute<Personnes, Auteurs> auteurses;
	public static volatile SetAttribute<Personnes, AuteursSeries> auteursSerieses;
}
