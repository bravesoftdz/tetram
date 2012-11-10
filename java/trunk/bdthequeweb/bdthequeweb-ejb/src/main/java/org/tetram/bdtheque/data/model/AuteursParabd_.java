package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.746+0100")
@StaticMetamodel(AuteursParabd.class)
public class AuteursParabd_ {
	public static volatile SingularAttribute<AuteursParabd, AuteursParabdId> id;
	public static volatile SingularAttribute<AuteursParabd, Personnes> personnes;
	public static volatile SingularAttribute<AuteursParabd, Parabd> parabd;
	public static volatile SingularAttribute<AuteursParabd, String> idAuteurParabd;
	public static volatile SingularAttribute<AuteursParabd, Date> dcAuteursParabd;
	public static volatile SingularAttribute<AuteursParabd, Date> dmAuteursParabd;
}
