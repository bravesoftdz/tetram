package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:12.635+0100")
@StaticMetamodel(VwEmpruntsId.class)
public class VwEmpruntsId_ {
	public static volatile SingularAttribute<VwEmpruntsId, String> idStatut;
	public static volatile SingularAttribute<VwEmpruntsId, String> idEdition;
	public static volatile SingularAttribute<VwEmpruntsId, String> idAlbum;
	public static volatile SingularAttribute<VwEmpruntsId, String> titrealbum;
	public static volatile SingularAttribute<VwEmpruntsId, String> idSerie;
	public static volatile SingularAttribute<VwEmpruntsId, Short> tome;
	public static volatile SingularAttribute<VwEmpruntsId, Short> integrale;
	public static volatile SingularAttribute<VwEmpruntsId, Short> tomedebut;
	public static volatile SingularAttribute<VwEmpruntsId, Short> tomefin;
	public static volatile SingularAttribute<VwEmpruntsId, Short> horsserie;
	public static volatile SingularAttribute<VwEmpruntsId, Short> notation;
	public static volatile SingularAttribute<VwEmpruntsId, String> titreserie;
	public static volatile SingularAttribute<VwEmpruntsId, String> idEditeur;
	public static volatile SingularAttribute<VwEmpruntsId, String> nomediteur;
	public static volatile SingularAttribute<VwEmpruntsId, String> idCollection;
	public static volatile SingularAttribute<VwEmpruntsId, String> nomcollection;
	public static volatile SingularAttribute<VwEmpruntsId, Short> prete;
	public static volatile SingularAttribute<VwEmpruntsId, Short> anneeedition;
	public static volatile SingularAttribute<VwEmpruntsId, String> isbn;
	public static volatile SingularAttribute<VwEmpruntsId, String> idEmprunteur;
	public static volatile SingularAttribute<VwEmpruntsId, String> nomemprunteur;
	public static volatile SingularAttribute<VwEmpruntsId, Short> pretemprunt;
	public static volatile SingularAttribute<VwEmpruntsId, Date> dateemprunt;
}
