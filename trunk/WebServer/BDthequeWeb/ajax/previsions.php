<?
include_once '../routines.php';
?>
<div id=listeprevisions_entete>
	<H1>Prévisions de sorties</H1>
</div>
<div id=listeprevisions_body>
	<TABLE border=0 width=100%>
		<tbody valign=top>
		<TR height=0>
			<TD></TD>
			<td></TD>
		</TR>
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
			<TD><A href=# onclick="return AjaxUpdate('detail', 'ficheserie.php?ref=<?echo $album->id_serie?>')"><?echo _out(display_titreserie($album))?></A></TD>
			<TD>Tome <?echo $album->tome?> en <?echo _out($mois[$album->moisparution].' '.$album->anneeparution)?></TD>
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
			<TD><A href=# onclick="return AjaxUpdate('detail', 'ficheserie.php?ref=<?echo $album->id_serie?>')"><?echo _out(display_titreserie($album))?></A></TD>
			<TD>Tome <?echo $album->tome?> en <?echo _out($mois[$album->moisparution].' '.$album->anneeparution)?></TD>
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
			<TD><A href=# onclick="return AjaxUpdate('detail', 'ficheserie.php?ref=<?echo $album->id_serie?>')"><?echo _out(display_titreserie($album))?></A></TD>
			<TD>Tome <?echo $album->tome?> en <?echo _out($mois[$album->moisparution].' '.$album->anneeparution)?></TD>
		</TR>
<?
	}
}
?>
	</tbody>
	</TABLE>
</div>