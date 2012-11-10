package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.261+0100")
@StaticMetamodel(Listes.class)
public class Listes_ {
	public static volatile SingularAttribute<Listes, ListesId> id;
	public static volatile SingularAttribute<Listes, String> idListe;
	public static volatile SingularAttribute<Listes, Integer> ordre;
	public static volatile SingularAttribute<Listes, Short> defaut;
	public static volatile SingularAttribute<Listes, Date> dcListes;
	public static volatile SingularAttribute<Listes, Date> dmListes;
	public static volatile SingularAttribute<Listes, String> libelle;
}
