<?php
include_once '../routines.php';
?>
<?php
$symbole_monetaire = get_option('moneysymbol');
$album = load_and_fetch('select * from /*DB_PREFIX*/albums where id_album '.format_string_null($_REQUEST['ref']));
$serie = load_and_fetch('select * from /*DB_PREFIX*/series where id_serie '.format_string_null($album->id_serie));
?>
<div class=entete>
	<H1><?php echo _out(display_titrealbum($album)) ?></H1>
</div>
<div class=body>
	<table border=0 width=100%>
		<tbody valign=top>
			<tr>
				<th align=right width=1>Série&nbsp;:</th>
				<td width=100%><?php echo AjaxLink('serie', $album->id_serie, display_titreserie($serie), 'série') ?></td>
				<td rowspan=10 align=right>
			</tr>
<?php
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
			<tr>
				<th align=right width=1></th>
				<td width=100%><?php echo _out($s)?></td>
			</tr>
<?php 
} 
?>

<?php 
if (NonZero($album->anneeparution) != '') 
{ 
?>
			<tr>
				<th align=right width=1>Parution&nbsp;:</th>
				<td width=100%><?php echo ($album->moisparution > 0 ? $mois[$album->moisparution].' ' : '').NonZero($album->anneeparution) ?></td>
			</tr>
<?php 
} 
?>

<?php
$rs = load_sql('select u.id_univers, u.nomunivers from /*DB_PREFIX*/univers u inner join /*DB_PREFIX*/albums_univers su on su.id_univers = u.id_univers where id_album'.format_string_null($album->id_album).' order by uppernomunivers');
if (mysql_num_rows($rs))
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Univers&nbsp;:</TH>
				<TD>
<?php
	while ($univers = mysql_fetch_object($rs))
		echo AjaxLink('univers', $univers>id_univers, format_titre($univers->nomunivers)).'<br>';
?>
				</TD>
			</TR>
<?php 
} 
mysql_free_result($rs);
?>

<?php
$rs = load_sql('select g.* from /*DB_PREFIX*/genres g inner join /*DB_PREFIX*/genreseries gs on g.id_genre = gs.id_genre where gs.id_serie '.format_string_null($album->id_serie)).' order by g.genre';
if (mysql_num_rows($rs))
{
	$s = '';
	while ($row = mysql_fetch_object($rs))
		$s .= ($s == ''?'':', ').format_titre($row->genre);
?>
			<tr>
				<th align=right width=1>Genre(s)&nbsp;:</th>
				<td><?php echo _out($s)?></td>
			</tr>
<?php 
} 
mysql_free_result($rs);
?>

<?php
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 0 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
			<tr>
				<th align=right width=1>Scénario&nbsp;:</th>
				<td>
<?php
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
?>
				</td>
			</tr>
<?php
} 
?>

<?php
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 1 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
			<tr>
				<th align=right width=1>Dessins&nbsp;:</th>
				<td>
<?php
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
?>
				</td>
			</tr>
<?php
} 
?>

<?php
$rs = load_sql('select p.* from /*DB_PREFIX*/personnes p inner join /*DB_PREFIX*/auteurs a on p.id_personne = a.id_personne where a.metier = 2 and a.id_album '.format_string_null($album->id_album).' order by a.metier, p.uppernompersonne');
if (mysql_num_rows($rs))
{
?>
			<tr>
				<th align=right width=1>Couleurs&nbsp;:</th>
				<td>
<?php
	while ($row = mysql_fetch_object($rs)) 
		echo AjaxLink('personne', $row->id_personne, format_titre($row->nompersonne), 'auteur').'<br>';
?>
				</td>
			</tr>
<?php
}
?>

<?php 
if ($album->sujetalbum || $serie->sujetserie) 
{
?>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<th align=right width=1>Histoire&nbsp;:</th>
				<td><?php echo _out($album->sujetalbum?$album->sujetalbum:$serie->sujetserie)?></td>
			</tr>
<?php
} 
?>

<?php 
if ($album->remarquesalbum || $serie->remarquesserie) 
{
?>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<th align=right width=1>Notes&nbsp;:</th>
				<td><?php echo _out($album->remarquesalbum?$album->remarquesalbum:$serie->remarquesserie)?></td>
			</tr>
<?php
} 
?>

<?php
$rs = load_sql('select * from /*DB_PREFIX*/editions where id_album'.format_string_null($album->id_album));
if (mysql_num_rows($rs) > 0)
{ 
?>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<th align=right width=1>Editions&nbsp;:</th>
			<!--/tr>
			<tr-->
				<td colspan=2>
<?php
	while ($edition = mysql_fetch_object($rs))
	{
		$editeur = load_and_fetch('select * from /*DB_PREFIX*/editeurs where id_editeur'.format_string_null($edition->id_editeur));
		$collection = load_and_fetch('select * from /*DB_PREFIX*/collections where id_collection'.format_string_null($edition->id_collection));
		$type_edition = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 3 and ref'.format_string_null($edition->typeedition));
		$reliure = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 2 and ref'.format_string_null($edition->reliure));
		$etat = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 1 and ref'.format_string_null($edition->etat));
?>
					<table>
						<tr>
							<td valign=top>
								<table>
									<tr>
										<th align=right width=1>Editeur&nbsp;:</th>
										<td width=100><?php echo $editeur->siteweb!=''?"<a target=_blank href=$editeur->siteweb>":''?><?php echo _out(format_titre($editeur->nomediteur))?><?php echo $editeur->siteweb!=''?'</a>':''?></td>
<?php 
		if ($collection->nomcollection) 
		{ 
?>
										<th align=right width=1>Collection&nbsp;:</th>
										<td><?php echo _out(format_titre($collection->nomcollection))?></td>
<?php 
		} 
?>
									</tr>
									<tr>
										<th align=right width=1>Année&nbsp;:</th>
										<td><?php echo NonZero($edition->anneeedition)?></td>
										<th align=right width=1>ISBN&nbsp;:</th>
										<td><?php echo format_isbn($edition->isbn)?></td>
									</tr>
									<tr>
										<th align=right width=1>Couleur&nbsp;:</th>
										<td><?php echo $edition->couleur?'Oui':'Non'?></td>
<?php 
		if ($edition->vo) 
		{ 
?>
										<th align=right width=1>VO&nbsp;:</th>
										<td><?php echo $edition->vo?'Oui':'Non'?></td>
<?php 
		} 
?>
									</tr>
									<tr>
										<th align=right width=1>Type&nbsp;d'édition&nbsp;:</th>
										<td><?php echo str_replace(' ', '&nbsp;', _out($type_edition->libelle))?></td>
										<th align=right width=1>Reliure&nbsp;:</th>
										<td><?php echo str_replace(' ', '&nbsp;', _out($reliure->libelle))?></td>
									</tr>
									<tr>
										<th align=right width=1>Etat&nbsp;:</th>
										<td><?php echo str_replace(' ', '&nbsp;', _out($etat->libelle))?></td>
										<th align=right width=1>Dédicacé&nbsp;:</th>
										<td><?php echo $edition->dedicace?'Oui':'Non'?></td>
									</tr>
<?php 
		if ($edition->dateachat || $edition->prix) 
		{ 
?>
									<tr>
										<th align=right width=1>Acheté&nbsp;le&nbsp;:</th>
										<td><?php echo str_replace(' ', '&nbsp;', _out(AfficheDateSQL($edition->dateachat)))?></td>
										<th align=right width=1>Prix&nbsp;:</th>
										<td><?php echo $edition->prix?str_replace(' ', '&nbsp;', number_format($edition->prix, 2, ',', ' ')).' '.$symbole_monetaire:''?></td>
									</tr>
<?php 
		} 
?>

<?php
		if ($edition->prixcote) 
		{ 
?>
									<tr>
										<th align=right width=1>Cote&nbsp;:</th>
										<td><?php echo sprintf('%s&nbsp;%s;&nbsp;(%d)', str_replace(' ', '&nbsp;', number_format($edition->prixcote, 2, ',', ' ')), $symbole_monetaire, $edition->anneecote)?></td>
									</tr>
<?php 
		} 
?>
									<tr><td>&nbsp;</td></tr>
								</table>
							</td>
<?php
		$images = load_sql('select * from /*DB_PREFIX*/couvertures where id_edition'.format_string_null($edition->id_edition).' order by categorieimage, ordre');
		$nrow = mysql_num_rows($images);
		if ($nrow > 0)
		{
			$image = mysql_fetch_object($images);
			$filename = build_img_filepath($rep_images, $db_prefix, $image->id_couverture);
			$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
							<td><a href=# onclick='return Zoom("zoomimage", "<?php echo $filename ?>")'><img border=0 height=150 src="<?php echo $filename ?>" alt="<?php echo _out($type_image->libelle)?>"></a>
						</tr>
<?php
			if ($nrow > 1)
			{
?>
						<tr>
							<td colspan=2 align=right>
<?php
				while ($image = mysql_fetch_object($images))
				{ 
					$filename = build_img_filepath($rep_images, $db_prefix, $image->id_couverture);
					$type_image = load_and_fetch('select * from /*DB_PREFIX*/listes where categorie = 6 and ref'.format_string_null($image->categorieimage));
?>
								<a href=# onclick='return Zoom("zoomimage", "<?php echo $filename ?>")'><img border=0 height=150 src="<?php echo $filename ?>" alt="<?php echo _out($type_image->libelle)?>"></a>
<?php
				} 
?>
							</td>
						</tr>
<?php
			} 
?>
<?php
		} 
?>
					</table>
<?php
	} 
?>
				</td>
			</tr>
<?php
} 
?>
		</tbody>
	</table>
</div>