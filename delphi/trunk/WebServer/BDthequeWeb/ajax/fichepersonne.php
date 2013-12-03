<?php
include_once '../routines.php';
?>
<?php
$personne = load_and_fetch('select * from /*DB_PREFIX*/personnes where id_personne'.format_string_null($_REQUEST['ref']));
?>
<div class=entete>
	<H1><?php echo _out(format_titre($personne->nompersonne))?></H1>
</div>
<div class=body>
	<TABLE border=0 width=100%>
		<TBODY valign=top align=left>
<?php
if ($personne->siteweb)
{
?>
			<tr>
				<th align=right width=1>Site&nbsp;:</th>
				<td><a href=<?php echo $personne->siteweb?>><?php echo $personne->siteweb?></a></td>
			</tr>
<?php
}
?>

<?php
if ($personne->biographie)
{
?>
			<tr>
				<th align=right width=1>Biographie&nbsp;:</th>
				<td><?php echo _out($personne->biographie)?></td>
			</tr>
<?php
}
?>

<?php
$rs = load_sql('select distinct la.id_serie, la.titreserie from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where coalesce(la.titreserie, \'\') <> \'\' and a.id_personne '.format_string_null($personne->id_personne).' order by uppertitreserie');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Série(s)&nbsp;:</TH>
				<TD>
<?php
	while ($row = $rs->fetch_object()) 
		echo AjaxLink('serie', $row->id_serie, display_titreserie($row), 's�rie').'<br>';
?>
				</TD>
			</TR>
<?php
} 
$rs->free();
?>

<?php
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 0 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Scénario&nbsp;:</TH>
				<TD>
<?php
	while ($row = $rs->fetch_object())
		echo AjaxLink('album', $row->id_album, display_titrealbum($row, false, true)).'<br>';
?>
				</TD>
			</TR>
<?php
}
$rs->free();
?>

<?php
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 1 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Dessins&nbsp;:</TH>
				<TD>
<?php
	while ($row = $rs->fetch_object())
		echo AjaxLink('album', $row->id_album, display_titrealbum($row, false, true)).'<br>';
?>
				</TD>
			</TR>
<?php
}
$rs->free();
?>

<?php
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 2 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if ($rs && $rs->num_rows)
{
?>
			<TR><TD>&nbsp;</TD></TR>
			<TR>
				<TH align=right width=1>Couleurs&nbsp;:</TH>
				<TD>
<?php
	while ($row = $rs->fetch_object())
		echo AjaxLink('album', $row->id_album, display_titrealbum($row, false, true)).'<br>';
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