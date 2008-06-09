<?
include_once '../routines.php';
?>
<div id=listemanquants_entete>
	<H1>Numéros manquants</H1>
</div>
<div id=listemanquants_body>
	<TABLE border=0 width=100%>
<?
$albums = load_sql('select * from /*DB_PREFIX*/albums_manquants order by uppertitreserie, tome');
$current_serie = null;

function update_serie()
{
	global $manquants_serie, $current_tome, $first_tome;

	if ($current_tome > $first_tome + 1)
		array_push($manquants_serie, sprintf('%d à %d', $first_tome, $current_tome));
	else
		for ($i = $first_tome; $i < $current_tome; $i++) 
			array_push($manquants_serie, $i);
	
}

function write_serie()
{
	global $current_album, $manquants_serie;
	global $c;
	
	update_serie();
?>
			<TR<?echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
				<TD><A href=# onclick="return AjaxUpdate('detail', 'ficheserie.php?ref=<?echo $current_album->id_serie?>')"><?echo _out(display_titreserie($current_album))?></A></TD>
				<TD><?echo implode(', ', $manquants_serie)?></TD>
			</TR>
<?
}

while ($album = mysql_fetch_object($albums))
{
	if ($current_serie != $album->id_serie)
	{
		if ($current_serie) write_serie();
		$current_serie = $album->id_serie;
		$first_tome = $album->tome;
		$current_tome = $first_tome;
		$manquants_serie = array();
	} 
	else
	{
		$tmp_tome = $album->tome;
		if ($tmp_tome <>$current_tome + 1) 
		{
			 update_serie();
			$first_tome = $tmp_tome;
		}
		$current_tome = $tmp_tome;
	}
	$current_album = $album;
}
if ($current_serie) write_serie();
?>
	</TABLE>
</div>