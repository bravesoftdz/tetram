<?
include_once '../routines.php';
?>
<div id=listeachats_entete>
	<H1>Prévisions d'achats</H1>
<?
$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where achat = 1 order by uppertitreserie, horsserie, integrale, tome, anneeparution, moisparution, uppertitrealbum';
$rs = load_sql($sql);
?>
	<TABLE width=100%>
		<TR>
			<TH class=TitreAlbum>Album</TH>
			<TH width=10></TH>
			<TH>Série</TH>
		</TR>
	</TABLE>
</div>
<div id=listeachats_body>
	<TABLE width=100%>
<?
	$c = 0;
	while ($row = mysql_fetch_object($rs)) 
	{
?>
		<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
			<TD class=TitreAlbum><A href=# onclick="return AjaxUpdate('detail', 'fichealbum.php?ref=<? echo $row->id_album ?>')"><? echo _out(display_titrealbum($row)) ?></A></TD>
			<TD width=10></TD>
			<TD class=Serie><A href=# onclick="return AjaxUpdate('detail', 'ficheserie.php?ref=<? echo $row->id_serie ?>')"><? echo _out(display_titreserie($row)) ?></A></TD>
		</TR>
<?
	}
?>
	</TABLE>
</div>