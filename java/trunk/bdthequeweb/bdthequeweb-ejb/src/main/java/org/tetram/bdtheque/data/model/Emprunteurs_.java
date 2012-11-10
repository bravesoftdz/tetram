package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.120+0100")
@StaticMetamodel(Emprunteurs.class)
public class Emprunteurs_ {
	public static volatile SingularAttribute<Emprunteurs, String> idEmprunteur;
	public static volatile SingularAttribute<Emprunteurs, Character> initialenomemprunteur;
	public static volatile SingularAttribute<Emprunteurs, Date> dcEmprunteurs;
	public static volatile SingularAttribute<Emprunteurs, Date> dmEmprunteurs;
	public static volatile SingularAttribute<Emprunteurs, String> nomemprunteur;
	public static volatile SingularAttribute<Emprunteurs, String> adresseemprunteur;
	public static volatile SetAttribute<Emprunteurs, Statut> statuts;
}
