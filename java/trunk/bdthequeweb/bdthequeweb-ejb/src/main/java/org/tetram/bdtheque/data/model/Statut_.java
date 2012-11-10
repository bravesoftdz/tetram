package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.511+0100")
@StaticMetamodel(Statut.class)
public class Statut_ {
	public static volatile SingularAttribute<Statut, String> idStatut;
	public static volatile SingularAttribute<Statut, Editions> editions;
	public static volatile SingularAttribute<Statut, Emprunteurs> emprunteurs;
	public static volatile SingularAttribute<Statut, Date> dateemprunt;
	public static volatile SingularAttribute<Statut, Short> pretemprunt;
	public static volatile SingularAttribute<Statut, Date> dcStatut;
	public static volatile SingularAttribute<Statut, Date> dmStatut;
}
