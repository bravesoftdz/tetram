package org.tetram.bdtheque.data.model;

import java.math.BigDecimal;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:13.525+0100")
@StaticMetamodel(VwPrixalbumsId.class)
public class VwPrixalbumsId_ {
	public static volatile SingularAttribute<VwPrixalbumsId, String> idAlbum;
	public static volatile SingularAttribute<VwPrixalbumsId, Short> horsserie;
	public static volatile SingularAttribute<VwPrixalbumsId, Short> tome;
	public static volatile SingularAttribute<VwPrixalbumsId, Short> integrale;
	public static volatile SingularAttribute<VwPrixalbumsId, Short> tomedebut;
	public static volatile SingularAttribute<VwPrixalbumsId, Short> tomefin;
	public static volatile SingularAttribute<VwPrixalbumsId, Long> nbalbums;
	public static volatile SingularAttribute<VwPrixalbumsId, String> idSerie;
	public static volatile SingularAttribute<VwPrixalbumsId, String> idEdition;
	public static volatile SingularAttribute<VwPrixalbumsId, String> idEditeur;
	public static volatile SingularAttribute<VwPrixalbumsId, BigDecimal> prix;
}
