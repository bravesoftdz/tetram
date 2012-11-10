package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.996+0100")
@StaticMetamodel(Couvertures.class)
public class Couvertures_ {
	public static volatile SingularAttribute<Couvertures, String> idCouverture;
	public static volatile SingularAttribute<Couvertures, Albums> albums;
	public static volatile SingularAttribute<Couvertures, String> idEdition;
	public static volatile SingularAttribute<Couvertures, Integer> ordre;
	public static volatile SingularAttribute<Couvertures, Short> stockagecouverture;
	public static volatile SingularAttribute<Couvertures, byte[]> imagecouverture;
	public static volatile SingularAttribute<Couvertures, Date> dcCouvertures;
	public static volatile SingularAttribute<Couvertures, Date> dmCouvertures;
	public static volatile SingularAttribute<Couvertures, String> fichiercouverture;
	public static volatile SingularAttribute<Couvertures, String> categorieimage;
}
