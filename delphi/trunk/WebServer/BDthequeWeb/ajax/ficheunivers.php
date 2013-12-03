<?php
include_once '../routines.php';
?>
<?php
$univers = load_and_fetch('select * from /*DB_PREFIX*/univers where id_univers '.format_string_null($_REQUEST['ref']));
?>
<div class=entete>
	<h1><?php echo _out(format_titre($univers->nomunivers))?></h1>
</div>
<div class=body>
	<table border=0 width=100%>
		<tbody valign=top>
<?php
if ($univers->siteweb)
{
?>
			<tr>
				<th align=right width=1>Site&nbsp;:</th>
				<td><a href=<?php echo $univers->siteweb?>><?php echo $univers->siteweb?></a></td>
			</tr>
<?php
}
?>

<?php
if ($univers->description)
{
?>
			<tr>
				<th align=right width=1>Description&nbsp;:</th>
				<td><?php echo _out($univers->description)?></td>
			</tr>
<?php
}
?>

<?php
$rs = load_sql('select distinct s.id_serie, s.titreserie from /*DB_PREFIX*/series_univers su inner join /*DB_PREFIX*/univers u on u.id_univers = su.id_univers inner join /*DB_PREFIX*/series s on s.id_serie = su.id_serie where u.id_univers '.format_string_null($univers->id_univers).' order by s.uppertitreserie';
if (mysql_num_rows($rs))
{
?>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<th align=right width=1>SÃ©rie(s)&nbsp;:</th>
				<td>
<?php
	while ($row = mysql_fetch_object($rs)) 
	{
?>
					<div class="treeNode">
<?php
		echo AjaxLink('serie', $row->id_serie, display_titreserie($row), 'série').'<br>';
?>
					</div>
					<div class="treeChildNode">
<?php
$rsa = load_sql('select distinct id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie from /*DB_PREFIX*/vw_liste_albums_univers where id_serie'.format_string_null($serie->id_serie).' and branche_univers containing \'|\' || '.($univers->id_univers).' || \'|\' order by horsserie, integrale, tome, anneeparution, moisparution');
if (mysql_num_rows($rsa))
{
	while ($album = mysql_fetch_object($rsa))
		echo AjaxLink('album', $album->id_album, display_titrealbum($album)).'<br>';
} 
mysql_free_result($rsa);
?>
					</div>
<?php
	}
?>
				</td>
			</tr>
<?php 
} 
mysql_free_result($rs);
?>
		</tbody>
	</table>
</div>