package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.074+0100")
@StaticMetamodel(Editeurs.class)
public class Editeurs_ {
	public static volatile SingularAttribute<Editeurs, String> idEditeur;
	public static volatile SingularAttribute<Editeurs, Character> initialenomediteur;
	public static volatile SingularAttribute<Editeurs, Date> dcEditeurs;
	public static volatile SingularAttribute<Editeurs, Date> dmEditeurs;
	public static volatile SingularAttribute<Editeurs, String> nomediteur;
	public static volatile SingularAttribute<Editeurs, String> siteweb;
	public static volatile SetAttribute<Editeurs, Editions> editionses;
	public static volatile SetAttribute<Editeurs, Collections> collectionses;
}
