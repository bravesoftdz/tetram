<?
include_once 'header.inc';
?>
<?
$personne = load_and_fetch('select * from /*DB_PREFIX*/personnes where id_personne'.format_string_null($_REQUEST['ref']));
?>
<H1><?echo format_titre($personne->nompersonne)?></H1>
<TABLE border=0 width=100%>
	<TBODY valign=top align=left>
<?
if ($personne->siteweb)
{
?>
		<tr>
			<th align=right>Site&nbsp;:</th>
			<td><a href=<?echo $personne->siteweb?>><?echo $personne->siteweb?></a></td>
		</tr>
<?
}
?>

<?
if ($personne->biographie)
{
?>
		<tr>
			<th align=right>Biographie&nbsp;:</th>
			<td><?echo $personne->biographie?></td>
		</tr>
<?
}
?>

<?
$rs = load_sql('select distinct la.id_serie, la.titreserie from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 0 and a.id_personne '.format_string_null($personne->id_personne).' order by uppertitreserie');
if (mysql_num_rows($rs))
{
?>
		<TR><TD width=1>&nbsp;</TD></TR>
		<TR>
			<TH align=right>Série(s)&nbsp;:</TH>
			<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
				<A href="ficheserie.php?ref=<?echo $row->id_serie?>"><?echo display_titreserie($row)?><br>
<?
	} 
?>
			</TD>
		</TR>
<?
} 
?>

<?
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 0 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if (mysql_num_rows($rs))
{
?>
		<TR><TD>&nbsp;</TD></TR>
		<TR>
			<TH align=right>Scénario&nbsp;:</TH>
			<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
				<A href="fichealbum.php?ref=<?echo $row->id_album?>"><?echo display_titrealbum($row, false, true)?><br>
<?
	} 
?>
			</TD>
		</TR>
<?
} 
?>

<?
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 1 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if (mysql_num_rows($rs))
{
?>
		<TR><TD>&nbsp;</TD></TR>
		<TR>
			<TH align=right>Dessins&nbsp;:</TH>
			<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
				<A href="fichealbum.php?ref=<?echo $row->id_album?>"><?echo display_titrealbum($row, false, true)?><br>
<?
	} 
?>
			</TD>
		</TR>
<?
} 
?>

<?
$rs = load_sql('select la.* from /*DB_PREFIX*/vw_liste_albums la inner join /*DB_PREFIX*/auteurs a on la.id_album = a.id_album where a.metier = 2 and a.id_personne '.format_string_null($personne->id_personne).' order by coalesce(uppertitrealbum, uppertitreserie), uppertitreserie, horsserie, integrale, tome, tomedebut, tomefin, anneeparution, moisparution');
if (mysql_num_rows($rs))
{
?>
		<TR><TD>&nbsp;</TD></TR>
		<TR>
			<TH align=right>Couleurs&nbsp;:</TH>
			<TD>
<?
	while ($row = mysql_fetch_object($rs)) 
	{
?>
				<A href="fichealbum.php?ref=<?echo $row->id_album?>"><?echo display_titrealbum($row, false, true)?><br>
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
<?
include_once 'footer.inc';
?>