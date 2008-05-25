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
<?

function load_sql($sql)
{
	prepare_sql($sql);
	$rs = mysql_query($sql) or die(mysql_error());
	return $rs;
}

function load_and_fetch($sql)
{
	$rs = load_sql($sql);
	$obj = mysql_fetch_object($rs);
	mysql_free_result($rs);
	return $obj;
}

$album = load_and_fetch('select * from /*DB_PREFIX*/albums where id_album '.format_string_null($_REQUEST['ref']));
$serie = load_and_fetch('select * from /*DB_PREFIX*/series where id_serie '.format_string_null($album->id_serie));

?>
		<H1><? echo display_titrealbum($album) ?></H1>
		<TABLE border=0 width=100%>
			<TBODY valign=top>
				<TR>
					<TH align=right>S&eacute;rie:</TH><TD width=100%><A href="ficheserie?ref=<? echo $album->id_serie ?>"><? echo display_titreserie($serie) ?></A></TD>
					<TD rowspan=10 align=right>
				</TR>
<?
$s = '';
 
if ($album->integrale) 
	$s = 'Intégrale'.(NonZero($album->tome)!=''?' n°'.NonZero($album->tome):'');
elseif ($album->horsserie) 
	$s = 'Hors série'.(NonZero($album->tome)!=''?' n°'.NonZero($album->tome):'');
elseif (NonZero($album->tome)!='') 
	$s = 'Tome '.NonZero($album->tome);

if ($s != '') 
{ 
?>
				<TR>
					<TH align=right></TH><TD width=100%><?echo $s?></TD>
				</TR>
<? 
} 
?>

<? 
if (NonZero($album->anneeparution) != '') 
{ 
?>
				<TR>
					<TH align=right>Parution:</TH><TD width=100%><?echo NonZero($album->anneeparution)?></TD>
				</TR>
<? 
} 
?>

<?
$rs = load_sql('select g.* from /*DB_PREFIX*/genres g inner join /*DB_PREFIX*/genreseries gs on g.id_genre = gs.id_genre where id_serie '.format_string_null($album->id_serie));
if (mysql_num_rows($rs))
{
	$s = '';
	while ($row = mysql_fetch_object($rs))
		$s .= ($s == ''?'':', ').format_titre($row->genre);
?>
				<TR>
					<TH align=right>Genre:</TH>
					<TD><?echo $s?></TD>
				</TR>
<? 
} 
mysql_free_result($rs);
?>

<?
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 0 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
				<TR>
					<TH align=right>Scénario:</TH>
					<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
						<A href="fichepersonne.php?ref=<?echo $row->id_personne?>"><?echo format_titre($row->nompersonne)?><br>
<?
	} 
?>
					</TD>
				</TR>
<?
} 
?>

<?
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 1 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
				<TR>
					<TH align=right>Dessin:</TH>
					<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
						<A href="fichepersonne.php?ref=<?echo $row->id_personne?>"><?echo format_titre($row->nompersonne)?><br>
<?
	} 
?>
					</TD>
				</TR>
<?
} 
?>

<?
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 2 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
				<TR>
					<TH align=right>Couleurs:</TH>
					<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
						<A href="fichepersonne.php?ref=<?echo $row->id_personne?>"><?echo format_titre($row->nompersonne)?><br>
<?
	} 
?>
					</TD>
				</TR>
<?
}
?>

<? 
if ($album->sujetalbum || $serie->sujetserie) 
{
?>
				<TR><TD>&nbsp;</TD></TR>
				<TR>
					<TH align=right>Histoire:</TH><TD><?echo $album->sujetalbum?$album->sujetalbum:$serie->sujetserie?></TD>
				</TR>
<?
} 
?>

<? 
if ($album->remarquesalbum || $serie->remarquesserie) 
{
?>
				<TR><TD>&nbsp;</TD></TR>
				<TR>
					<TH align=right>Notes:</TH><TD><?echo $album->remarquesalbum?$album->remarquesalbum:$serie->remarquesserie?></TD>
				</TR>
<?
} 
?>

<?
$rs = load_sql('select * from /*DB_PREFIX*/editions where id_album'.format_string_null($album->id_album));
if (mysql_num_rows($rs) > 0)
{ 
?>
				<TR><TD>&nbsp;</TD></TR>
				<TR>
					<TH align=right>Editions:</TH>
					<TD>
<?
	while ($edition = mysql_fetch_object($rs))
	{
		$editeur = load_and_fetch('select * from /*DB_PREFIX*/editeurs where id_editeur'.format_string_null($edition->id_editeur));
		$collection = load_and_fetch('select * from /*DB_PREFIX*/collections where id_collection'.format_string_null($edition->id_collection));
		$type_edition = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 3 and ref'.format_string_null($edition->typeedition));
		$reliure = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 2 and ref'.format_string_null($edition->reliure));
		$etat = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 1 and ref'.format_string_null($edition->etat));
?>
						<TABLE>
							<TR>
								<TD>
									<TABLE>
										<TR>
											<TH align=right>Editeur:</TH><TD width=100><?echo $editeur->siteweb!=''?"<A target=_blank href=$editeur->siteweb>":''?><?echo format_titre($editeur->nomediteur)?><?echo $editeur->siteweb!=''?'</a>':''?></TD>
											<? if ($collection->nomcollection) { ?>
											<TH align=right>Collection:</TH><TD><?echo format_titre($collection->nomcollection)?></TD>
											<? } ?>
										</TR>
										<TR>
											<TH align=right>Année:</TH><TD><?echo NonZero($edition->anneeedition)?></TD>
											<TH align=right>ISBN:</TH><TD><?echo format_isbn($edition->isbn)?></TD>
										</TR>
										<TR>
											<TH align=right>Couleur:</TH><TD><?echo $edition->couleur?'Oui':'Non'?></TD>
											<? if ($edition->vo) { ?>
											<TH align=right>VO:</TH><TD><?echo $edition->vo?'Oui':'Non'?></TD>
											<? } ?>
										</TR>
										<TR>
											<TH align=right>Type&nbsp;d'édition:</TH><TD><?echo str_replace(' ', '&nbsp;', $type_edition->libelle)?></TD>
											<TH align=right>Reliure:</TH><TD><?echo str_replace(' ', '&nbsp;', $reliure->libelle)?></TD>
										</TR>
										<TR>
											<TH align=right>Etat:</TH><TD><?echo str_replace(' ', '&nbsp;', $etat->libelle)?></TD>
											<TH align=right>Dédicacée:</TH><TD><?echo $edition->dedicace?'Oui':'Non'?></TD>
										</TR>
										<TR>
											<? if ($edition->dateachat) { ?>
											<TH align=right>Acheté&nbsp;le:</TH><TD><?echo str_replace(' ', '&nbsp;', AfficheDateSQL($edition->dateachat))?></TD>
											<? } ?>
										</TR>
										<TR><TD>&nbsp;</TD></TR>
									</TABLE>
								</TD>
							<?
		$images = load_sql('select * from /*DB_PREFIX*/couvertures where id_edition'.format_string_null($edition->id_edition).' order by categorieimage, ordre');
		$nrow = mysql_num_rows($images);
		if ($nrow > 0)
		{
			$image = mysql_fetch_object($images);
			$filename = $rep_images.$db_prefix.$image->id_couverture.'.jpg';
			$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
								<TD><A href="<? echo $filename ?>" target=zoomimage><img border=0 height=150 src="<? echo $filename ?>" alt="<?echo $type_image->libelle?>"></a>
							</TR>
<?
			if ($nrow > 1)
			{
?>
							<TR>
								<TD colspan=2 align=right>
<?
				while ($image = mysql_fetch_object($images))
				{ 
					$filename = $rep_images.$db_prefix.$image->id_couverture.'.jpg';
					$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
									<A href="<? echo $filename ?>" target=zoomimage><img border=0 height=150 src="<? echo $filename ?>" alt="<?echo $type_image->libelle?>"></a>
<?
				} 
?>
								</TD>
							</TR>
<?
			} 
?>
<?
		} 
?>
						</TABLE>
<?
	} 
?>
					</TD>
				</TR>
<?
} 
?>
			</TBODY>
		</TABLE>
		<P>
		<A href="javascript:history.back();">Retour</A> - <A href="repertoire.php">Répertoire</A><BR>
	</BODY>
</HTML>