<?
include_once '../routines.php';
?>
<?
$symbole_monetaire = get_option('moneysymbol');
$album = load_and_fetch('select * from /*DB_PREFIX*/albums where id_album '.format_string_null($_REQUEST['ref']));
$serie = load_and_fetch('select * from /*DB_PREFIX*/series where id_serie '.format_string_null($album->id_serie));
?>
<div class=entete>
	<H1><? echo _out(display_titrealbum($album)) ?></H1>
</div>
<div class=body>
	<TABLE border=0 width=100%>
		<TBODY valign=top>
			<TR>
				<TH align=right width=1>Série&nbsp;:</TH><TD width=100%><?echo AjaxLink('serie', $album->id_serie, display_titreserie($serie), 'série') ?></TD>
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
				<TH align=right></TH><TD width=100%><?echo _out($s)?></TD>
			</TR>
<? 
} 
?>

<? 
if (NonZero($album->anneeparution) != '') 
{ 
?>
			<TR>
				<TH align=right>Parution&nbsp;:</TH><TD width=100%><?echo ($album->moisparution > 0 ? $mois[$album->moisparution].' ' : '').NonZero($album->anneeparution) ?></TD>
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
				<TH align=right>Genre(s)&nbsp;:</TH>
				<TD><?echo _out($s)?></TD>
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
				<TH align=right>Scénario&nbsp;:</TH>
				<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
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
				<TH align=right>Dessins&nbsp;:</TH>
				<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
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
				<TH align=right>Couleurs&nbsp;:</TH>
				<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
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
				<TH align=right>Histoire&nbsp;:</TH><TD><?echo _out($album->sujetalbum?$album->sujetalbum:$serie->sujetserie)?></TD>
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
				<TH align=right>Notes&nbsp;:</TH><TD><?echo _out($album->remarquesalbum?$album->remarquesalbum:$serie->remarquesserie)?></TD>
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
				<TH align=right>Editions&nbsp;:</TH>
			<!--/tr>
			<tr-->
				<TD colspan=2>
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
							<TD valign=top>
								<TABLE>
									<TR>
										<TH align=right>Editeur&nbsp;:</TH><TD width=100><?echo $editeur->siteweb!=''?"<A target=_blank href=$editeur->siteweb>":''?><?echo _out(format_titre($editeur->nomediteur))?><?echo $editeur->siteweb!=''?'</a>':''?></TD>
<? 
		if ($collection->nomcollection) 
		{ 
?>
										<TH align=right>Collection&nbsp;:</TH><TD><?echo _out(format_titre($collection->nomcollection))?></TD>
<? 
		} 
?>
									</TR>
									<TR>
										<TH align=right>Année&nbsp;:</TH><TD><?echo NonZero($edition->anneeedition)?></TD>
										<TH align=right>ISBN&nbsp;:</TH><TD><?echo format_isbn($edition->isbn)?></TD>
									</TR>
									<TR>
										<TH align=right>Couleur&nbsp;:</TH><TD><?echo $edition->couleur?'Oui':'Non'?></TD>
<? 
		if ($edition->vo) 
		{ 
?>
										<TH align=right>VO&nbsp;:</TH><TD><?echo $edition->vo?'Oui':'Non'?></TD>
<? 
		} 
?>
									</TR>
									<TR>
										<TH align=right>Type&nbsp;d'édition&nbsp;:</TH><TD><?echo str_replace(' ', '&nbsp;', _out($type_edition->libelle))?></TD>
										<TH align=right>Reliure&nbsp;:</TH><TD><?echo str_replace(' ', '&nbsp;', _out($reliure->libelle))?></TD>
									</TR>
									<TR>
										<TH align=right>Etat&nbsp;:</TH><TD><?echo str_replace(' ', '&nbsp;', _out($etat->libelle))?></TD>
										<TH align=right>Dédicacé&nbsp;:</TH><TD><?echo $edition->dedicace?'Oui':'Non'?></TD>
									</TR>
<? 
		if ($edition->dateachat || $edition->prix) 
		{ 
?>
									<TR>
										<TH align=right>Acheté&nbsp;le&nbsp;:</TH><TD><?echo str_replace(' ', '&nbsp;', _out(AfficheDateSQL($edition->dateachat)))?></TD>
										<TH align=right>Prix&nbsp;:</TH><TD><?echo $edition->prix?str_replace(' ', '&nbsp;', number_format($edition->prix, 2, ',', ' ')).' '.$symbole_monetaire:''?></TD>
									</TR>
<? 
		} 
?>

<?
		if ($edition->prixcote) 
		{ 
?>
									<TR>
										<TH align=right>Cote&nbsp;:</TH><TD><?echo sprintf('%s&nbsp;%s;&nbsp;(%d)', str_replace(' ', '&nbsp;', number_format($edition->prixcote, 2, ',', ' ')), $symbole_monetaire, $edition->anneecote)?></TD>
									</TR>
<? 
		} 
?>
									<TR><TD>&nbsp;</TD></TR>
								</TABLE>
							</TD>
<?
		$images = load_sql('select * from /*DB_PREFIX*/couvertures where id_edition'.format_string_null($edition->id_edition).' order by categorieimage, ordre');
		$nrow = mysql_num_rows($images);
		if ($nrow > 0)
		{
			$image = mysql_fetch_object($images);
			$filename = build_img_filepath($rep_images, $db_prefix, $image->id_couverture);
			$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
							<TD><A href=# onclick='return Zoom("zoomimage", "<? echo $filename ?>")'><img border=0 height=150 src="<? echo $filename ?>" alt="<?echo _out($type_image->libelle)?>"></a>
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
			        $filename = build_img_filepath($rep_images, $db_prefix, $image->id_couverture);
					$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
								<A href=# onclick='return Zoom("zoomimage", "<? echo $filename ?>")'><img border=0 height=150 src="<? echo $filename ?>" alt="<?echo _out($type_image->libelle)?>"></a>
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
</div>