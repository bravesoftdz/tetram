<?
require_once 'db.php';
require_once 'routines.php';
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//FR">
<HTML>
	<HEAD>
		<TITLE>BDThèque</TITLE>
		<LINK rel="stylesheet" href="styles.css" type="text/css">
		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</HEAD>
	<BODY>
		<TABLE width=100%>
				<TR>
					<TD align=center>
						<TABLE border=0>
								<TR>
									<TH>Album</TH>
									<TH width=10></TH>
									<TH>Serie</TH>
								</TR>
<?
$ref = $_REQUEST['ref'];
if ($ref == '-1') $ref = '';
$ref = format_string_null($ref, true);

switch ($_REQUEST['GroupBy'])
{
	case 1: // par année
		$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where anneeparution '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
		break;
	case 2: // par collection
		$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/editions e on a.id_album = e.id_album left join /*DB_PREFIX*/series s on a.id_serie = s.id_serie where e.id_collection '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
		break;
	case 3: // par editeur
		$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/editions e on a.id_album = e.id_album left join /*DB_PREFIX*/series s on a.id_serie = s.id_serie where e.id_editeur '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
		break;
	case 4: // par genre
		$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, a.id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums a left join /*DB_PREFIX*/genreseries gs on gs.id_serie = a.id_serie left join /*DB_PREFIX*/genres g on gs.id_genre = g.id_genre where g.id_genre '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
		break;
	case 5: // par série
		$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where id_serie '.$ref.' order by horsserie, integrale, tome, anneeparution, moisparution, uppertitrealbum';
		break;
	case 0:
	default: // par titre
		$sql = 'select a.id_album, a.titrealbum, a.tome, a.tomedebut, a.tomefin, a.horsserie, a.integrale, a.moisparution, a.anneeparution, a.id_serie, s.titreserie, a.achat, a.complet from /*DB_PREFIX*/albums a left join /*DB_PREFIX*/series s on s.id_serie = a.id_serie where coalesce(a.initialetitrealbum, s.initialetitreserie) '.$ref.' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution';
}
prepare_sql($sql);
$rs = mysql_query($sql) or die(mysql_error());
while ($row = mysql_fetch_object($rs)) 
{
?>
								<TR>
									<TD class=TitreAlbum><A href="fichealbum.php?ref=<? echo $row->id_album ?>"><? echo display_titrealbum($row) ?></A></TD>
									<TD></TD>
									<TD class=Serie><A href="ficheserie.php?ref=<? echo $row->id_serie ?>"><? echo display_titreserie($row) ?></A></TD>
								</TR>
<?
}
?>
						</TABLE>
					</TD>
				</TR>
		</TABLE>
	</BODY>
</HTML>
