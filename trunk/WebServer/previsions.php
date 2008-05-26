<?
include_once 'header.inc';
?>
<H1>Prévisions de sorties</H1>
<TABLE border=0 width=100%>
<?
$albums = load_sql('select * from /*DB_PREFIX*/previsions_sorties where anneeparution > '.date('Y').' order by anneeparution desc, moisparution desc, uppertitreserie');
if (mysql_num_rows($albums))
{
?>
	<TR>
		<TD colspan=2><hr width=90%><H3>Prochaines ann&eacute;es</H3></TD>
	</TR>
<?
	while ($album = mysql_fetch_object($albums))
	{ 
?>
 	<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
		<TD><A href="ficheserie.php?ref=<?echo $album->id_serie?>"><?echo display_titreserie($album)?></A></TD>
		<TD>Tome <?echo $album->tome?> en <?echo $mois[$album->moisparution].' '.$album->anneeparution?></TD>
	</TR>
<?
	}
}
?>

<?
$albums = load_sql('select * from /*DB_PREFIX*/previsions_sorties where anneeparution = '.date('Y').' order by anneeparution desc, moisparution desc, uppertitreserie');
if (mysql_num_rows($albums))
{
?>
	<TR valign=top>
		<TD colspan=2><hr width=90%><H3>Ann&eacute;e en cours</H3></TD>
	</TR>
<?
	while ($album = mysql_fetch_object($albums))
	{ 
?>
 	<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
		<TD><A href="ficheserie.php?ref=<?echo $album->id_serie?>"><?echo display_titreserie($album)?></A></TD>
		<TD>Tome <?echo $album->tome?> en <?echo $mois[$album->moisparution].' '.$album->anneeparution?></TD>
	</TR>
<?
	}
}
?>

<?
$albums = load_sql('select * from /*DB_PREFIX*/previsions_sorties where anneeparution < '.date('Y').' order by anneeparution desc, moisparution desc, uppertitreserie');
if (mysql_num_rows($albums))
{
?>
	<TR valign=top>
		<TD colspan=2><hr width=90%><H3>Années passées</H3></TD>
	</TR>
<?
	while ($album = mysql_fetch_object($albums))
	{ 
?>
 	<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
		<TD><A href="ficheserie.php?ref=<?echo $album->id_serie?>"><?echo display_titreserie($album)?></A></TD>
		<TD>Tome <?echo $album->tome?> en <?echo $mois[$album->moisparution].' '.$album->anneeparution?></TD>
	</TR>
<?
	}
}
?>

</TABLE>
<?
include_once 'footer.inc';
?>
