<?
include_once '../routines.php';
?>
<?
$serie = load_and_fetch('select * from /*DB_PREFIX*/series where id_serie '.format_string_null($_REQUEST['ref']));
$editeur = load_and_fetch('select * from /*DB_PREFIX*/editeurs where id_editeur'.format_string_null($serie->id_editeur));
$collection = load_and_fetch('select * from /*DB_PREFIX*/collections where id_collection'.format_string_null($serie->id_collection));
?>
<div id=detail_entete>
	<H1><?echo _out(display_titreserie($serie))?></H1>
</div>
<div id=detail_body>
	<TABLE border=0 width=100%>
		<TBODY valign=top>
			<TR>
				<TH align=right width=1></TH><TD width=100%><?echo $serie->terminee==1?'Serie terminée':'Serie en cours'?></TD>
			</TR>
			<TR>
				<TH align=right>Editeur&nbsp;:</TH><TD width=100%><?echo $editeur->siteweb?"<a target=_blank href=$editeur->siteweb>":''?><?echo _out(format_titre($editeur->nomediteur))?><?echo $editeur->siteweb?"</a>":''?></TD>
			</TR>
			<TR>
				<TH align=right>Collection&nbsp;:</TH><TD><?echo _out(format_titre($collection->nomcollection))?></TD>
			</TR>
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
if ($serie->sujetserie) 
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right>Histoire&nbsp;:</TH><TD><?echo _out($serie->sujetserie)?></TD>
			</TR>
<?
} 
?>

<? 
if ($serie->remarquesserie) 
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right>Notes&nbsp;:</TH><TD><?echo _out($serie->remarquesserie)?></TD>
			</TR>
<?
} 
?>

<?
$rs = load_sql('select id_album, titrealbum, integrale, horsserie, tome, tomedebut, tomefin, id_serie from /*DB_PREFIX*/albums where id_serie'.format_string_null($serie->id_serie).' order by horsserie, integrale, tome');
if (mysql_num_rows($rs))
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right>Albums&nbsp;:</TH>
				<TD>
<?
	while ($album = mysql_fetch_object($rs))
		echo AjaxLink('album', $album->id_album, display_titrealbum($album)).'<br>';
?>
				</TD>
			</TR>
<? 
} 
?>
		</TBODY>
	</TABLE>
</div>