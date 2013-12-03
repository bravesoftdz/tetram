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
$rs = load_sql('select distinct s.id_serie, s.titreserie from /*DB_PREFIX*/vw_liste_albums_univers su inner join /*DB_PREFIX*/series s on s.id_serie = su.id_serie where branche_univers like \'%|'.($univers->id_univers).'|%\' order by s.uppertitreserie');
if ($rs && $rs->num_rows)
{
?>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<th align=right width=1>Album(s)&nbsp;:</th>
				<td>
<?php
	while ($serie = $rs->fetch_object()) 
	{
?>
					<div class="treeNode">
<?php
		echo AjaxLink('serie', $serie->id_serie, display_titreserie($serie), 'série').'<br>';
?>
					</div>
					<div class="treeChildNode">
<?php
		$rsa = load_sql('select distinct id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie from /*DB_PREFIX*/vw_liste_albums_univers where id_serie'.format_string_null($serie->id_serie).' and branche_univers like \'%|'.($univers->id_univers).'|%\' order by horsserie, integrale, tome, anneeparution, moisparution');
		if ($rsa && $rsa->num_rows)
		{
			while ($album = $rsa->fetch_object())
				echo AjaxLink('album', $album->id_album, display_titrealbum($album)).'<br>';
		} 
		$rsa->free();
?>
					</div>
<?php
	}
?>
				</td>
			</tr>
<?php 
} 
$rs->free();
?>
		</tbody>
	</table>
</div>