package org.tetram.bdtheque.data.model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="Dali", date="2012-11-10T16:51:11.606+0100")
@StaticMetamodel(Albums.class)
public class Albums_ {
	public static volatile SingularAttribute<Albums, String> idAlbum;
	public static volatile SingularAttribute<Albums, Short> moisparution;
	public static volatile SingularAttribute<Albums, Short> anneeparution;
	public static volatile SingularAttribute<Albums, String> idSerie;
	public static volatile SingularAttribute<Albums, Short> tome;
	public static volatile SingularAttribute<Albums, Short> tomedebut;
	public static volatile SingularAttribute<Albums, Short> tomefin;
	public static volatile SingularAttribute<Albums, Short> horsserie;
	public static volatile SingularAttribute<Albums, Short> integrale;
	public static volatile SingularAttribute<Albums, Short> achat;
	public static volatile SingularAttribute<Albums, Integer> nbeditions;
	public static volatile SingularAttribute<Albums, Integer> complet;
	public static volatile SingularAttribute<Albums, Character> initialetitrealbum;
	public static volatile SingularAttribute<Albums, Date> dcAlbums;
	public static volatile SingularAttribute<Albums, Date> dmAlbums;
	public static volatile SingularAttribute<Albums, String> titrealbum;
	public static volatile SingularAttribute<Albums, String> soundextitrealbum;
	public static volatile SingularAttribute<Albums, Short> notation;
	public static volatile SingularAttribute<Albums, String> sujetalbum;
	public static volatile SingularAttribute<Albums, String> remarquesalbum;
	public static volatile SetAttribute<Albums, Editions> editionses;
	public static volatile SetAttribute<Albums, Couvertures> couvertureses;
	public static volatile SetAttribute<Albums, Auteurs> auteurses;
}
