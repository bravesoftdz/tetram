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
	<TABLE border=0 width=100%>
		<TBODY valign=top>
			<TR>
				<TH align=right width=1></TH><TD width=100%><?php echo $serie->terminee==1?'Serie terminée':'Serie en cours'?></TD>
			</TR>
			<TR>
				<TH align=right width=1>Editeur&nbsp;:</TH><TD width=100%><?php echo $editeur->siteweb?"<a target=_blank href=$editeur->siteweb>":''?><?php echo _out(format_titre($editeur->nomediteur))?><?php echo $editeur->siteweb?"</a>":''?></TD>
			</TR>
			<TR>
				<TH align=right width=1>Collection&nbsp;:</TH><TD><?php echo _out(format_titre($collection->nomcollection))?></TD>
			</TR>
<?php
$rs = load_sql('select g.* from /*DB_PREFIX*/genres g inner join /*DB_PREFIX*/genreseries gs on g.id_genre = gs.id_genre where gs.id_serie '.format_string_null($album->id_serie)).' order by g.genre';
if (mysql_num_rows($rs))
{
	$s = '';
	while ($row = mysql_fetch_object($rs))
		$s .= ($s == ''?'':', ').format_titre($row->genre);
?>
			<TR>
				<TH align=right width=1>Genre(s)&nbsp;:</TH>
				<TD><?php echo _out($s)?></TD>
			</TR>
<?php 
} 
mysql_free_result($rs);
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
if (mysql_num_rows($rs))
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Albums&nbsp;:</TH>
				<TD>
<?php
	while ($album = mysql_fetch_object($rs))
		echo AjaxLink('album', $album->id_album, display_titrealbum($album)).'<br>';
?>
				</TD>
			</TR>
<?php 
} 
?>
		</TBODY>
	</TABLE>
</div>