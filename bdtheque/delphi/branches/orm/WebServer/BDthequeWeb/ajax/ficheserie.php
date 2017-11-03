<?php
include_once '../routines.php';
?>
<?php
$serie = load_and_fetch('select * from /*DB_PREFIX*/series where id_serie '.format_string_null($_REQUEST['ref']));
$editeur = load_and_fetch('select * from /*DB_PREFIX*/editeurs where id_editeur'.format_string_null($serie->id_editeur));
$collection = load_and_fetch('select * from /*DB_PREFIX*/collections where id_collection'.format_string_null($serie->id_collection));
?>
<div class=entete>
	<H1><?php echo _out(display_titreserie($serie))?></H1>
</div>
<div class=body>
	<table border=0 width=100%>
		<tbody valign=top>
			<tr>
				<th align=right width=1></th><td width=100%><?php echo $serie->terminee==1?'Serie terminée':'Serie en cours'?></TD>
			</tr>
			<tr>
				<th align=right width=1>Editeur&nbsp;:</TH><TD width=100%><?php echo $editeur->siteweb?"<a target=_blank href=$editeur->siteweb>":''?><?php echo _out(format_titre($editeur->nomediteur))?><?php echo $editeur->siteweb?"</a>":''?></TD>
			</tr>
<?php
if ($collection) 
{
?>
			<tr>
				<th align=right width=1>Collection&nbsp;:</TH><TD><?php echo _out(format_titre($collection->nomcollection))?></TD>
			</tr>
<?php 
} 
?>

<?php
$rs = load_sql('select u.id_univers, u.nomunivers from /*DB_PREFIX*/univers u inner join /*DB_PREFIX*/series_univers su on su.id_univers = u.id_univers where su.id_serie'.format_string_null($serie->id_serie).' order by u.uppernomunivers');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Univers&nbsp;:</TH>
				<TD>
<?php
	while ($univers = $rs->fetch_object())
		echo AjaxLink('univers', $univers->id_univers, format_titre($univers->nomunivers)).'<br>';
?>
				</TD>
			</TR>
<?php 
} 
$rs->free();
?>

<?php
$rs = load_sql('select g.* from /*DB_PREFIX*/genres g inner join /*DB_PREFIX*/genreseries gs on g.id_genre = gs.id_genre where gs.id_serie '.format_string_null($serie->id_serie).' order by g.genre');
if ($rs && $rs->num_rows)
{
	$s = '';
	while ($row = $rs->fetch_object())
		$s .= ($s == ''?'':', ').format_titre($row->genre);
?>
			<TR>
				<TH align=right width=1>Genre(s)&nbsp;:</TH>
				<TD><?php echo _out($s)?></TD>
			</TR>
<?php 
} 
$rs->free();
?>

<?php 
if ($serie->sujetserie) 
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Histoire&nbsp;:</TH><TD><?php echo _out($serie->sujetserie)?></TD>
			</TR>
<?php
} 
?>

<?php 
if ($serie->remarquesserie) 
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Notes&nbsp;:</TH><TD><?php echo _out($serie->remarquesserie)?></TD>
			</TR>
<?php
} 
?>

<?php
$rs = load_sql('select id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie from /*DB_PREFIX*/albums where id_serie'.format_string_null($serie->id_serie).' order by horsserie, integrale, tome, anneeparution, moisparution');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Albums&nbsp;:</TH>
				<TD>
<?php
	while ($album = $rs->fetch_object())
		echo AjaxLink('album', $album->id_album, display_titrealbum($album)).'<br>';
?>
				</TD>
			</TR>
<?php 
} 
$rs->free();
?>
		</tbody>
	</table>
</div>