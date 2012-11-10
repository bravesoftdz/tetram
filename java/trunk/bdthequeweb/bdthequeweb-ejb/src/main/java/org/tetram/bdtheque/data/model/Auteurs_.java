package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.715+0100")
@StaticMetamodel(Auteurs.class)
public class Auteurs_ {
	public static volatile SingularAttribute<Auteurs, AuteursId> id;
	public static volatile SingularAttribute<Auteurs, Personnes> personnes;
	public static volatile SingularAttribute<Auteurs, Albums> albums;
	public static volatile SingularAttribute<Auteurs, String> idAuteur;
	public static volatile SingularAttribute<Auteurs, Date> dcAuteurs;
	public static volatile SingularAttribute<Auteurs, Date> dmAuteurs;
}
