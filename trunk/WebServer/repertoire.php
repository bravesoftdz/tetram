<?
include_once 'header.inc';
?>
<?
$ref = $_REQUEST['ref'];
if ($ref == '-1') $ref = '';
$ref = format_string_null($ref, true);

if (isset($_REQUEST['GroupBy']))
{
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
	$rs = load_sql($sql);
?>
<TABLE width=100%>
	<TR>
		<TH width=50%>Album</TH>
		<TH width=10></TH>
		<TH>Série</TH>
	</TR>
<?
	$c = 0;
	while ($row = mysql_fetch_object($rs)) 
	{
?>
	<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
		<TD class=TitreAlbum><A href="fichealbum.php?ref=<? echo $row->id_album ?>"><? echo _out(display_titrealbum($row)) ?></A></TD>
		<TD></TD>
		<TD class=Serie><A href="ficheserie.php?ref=<? echo $row->id_serie ?>"><? echo _out(display_titreserie($row)) ?></A></TD>
	</TR>
<?
	}
?>
</TABLE>
<?
}
else
{
	$albums = load_and_fetch('select count(*) as c from /*DB_PREFIX*/albums');
	$editions = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editions');
	$series = load_and_fetch('select count(*) as c from /*DB_PREFIX*/series');
	$auteurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/personnes');
	$editeurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editeurs');
?>
<TABLE width=100% height=100%>
<tbody valign=middle>
	<TR>
		<TD valign=middle align=center>
			<TABLE cellpadding=0 cellspacing=0 border=0>
				<TR>
					<TD>
						<FONT size=+4>BDThèque</FONT>
					</TD>
				</TR>
				<TR>
					<TD>
						<IMG src=graphics/acceuil.jpg border=0>
					</TD>
				</TR>
				<TR>
					<TD align=right>
						<A href=mailto:dev@tetram.org><IMG border=0 src=graphics/logo.jpg></A>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD valign=center align=center>
			<table height=100%>
			<tr><td>
			<b><?echo $albums->c?></b> albums connus pour <b><?echo $editions->c?></b> albums dans la biliothèque,<br>
			répartis sur <b><?echo $series->c?></b> séries chez <b><?echo $editeurs->c?></b> éditeurs,<br>
			et réalisés par <b><?echo $auteurs->c?></b> auteurs.
			</table>
		</TD>
	</TR>
</TABLE>
<?	
}
?>
<?
include_once 'footer.inc';
?>