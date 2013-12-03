<?php
include_once '../routines.php';
?>
<div class=entete>
	<H1>Numéros manquants</H1>
</div>
<div class=body>
	<TABLE border=0 width=100%>
<?php
$albums = load_sql('select * from /*DB_PREFIX*/albums_manquants order by uppertitreserie, tome');
$current_serie = null;

function update_serie()
{
	global $manquants_serie, $current_tome, $first_tome;

	if ($current_tome > $first_tome + 1)
		array_push($manquants_serie, sprintf('%d à %d', $first_tome, $current_tome));
	else
		for ($i = $first_tome; $i <= $current_tome; $i++) 
			array_push($manquants_serie, $i);
	
}

function write_serie()
{
	global $current_album, $manquants_serie;
	global $c;
	
	update_serie();
?>
			<TR<?php echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
				<TD><?php echo AjaxLink('serie', $current_album->id_serie, display_titreserie($current_album), 'série')?></TD>
				<TD><?php echo implode(', ', $manquants_serie)?></TD>
			</TR>
<?php
}

$current_serie = -1;
while ($album = $albums->fetch_object())
{
	if ($current_serie != $album->id_serie)
	{
		if ($current_serie != -1) write_serie();
		$current_serie = $album->id_serie;
		$first_tome = $album->tome;
		$current_tome = $first_tome;
		$manquants_serie = array();
	} 
	else
	{
		$tmp_tome = $album->tome;
		if ($tmp_tome != $current_tome + 1) 
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