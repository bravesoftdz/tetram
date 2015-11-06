<?php
include_once '../routines.php';
?>
<div class='entete height60'>
	<H1>Prévisions d'achats</H1>
<?php
$sql = 'select id_album, titrealbum, tome, tomedebut, tomefin, horsserie, integrale, moisparution, anneeparution, id_serie, titreserie, achat, complet from /*DB_PREFIX*/vw_liste_albums where achat = 1 order by uppertitreserie, horsserie, integrale, tome, anneeparution, moisparution, uppertitrealbum';
$rs = load_sql($sql);
?>
	<TABLE width=100%>
		<TR>
			<TH width=30% align=left>Album</TH>
			<TH width=10></TH>
			<TH width=30% align=left>Série</TH>
			<TH width=10></TH>
			<TH width=30% align=left>Parution</TH>
		</TR>
	</TABLE>
</div>
<div class='body top60'>
	<TABLE width=100%>
<?php
	$c = 0;
	while ($row = $rs->fetch_object()) 
	{
?>
		<TR<?php echo $c++ % 2?' bgcolor=#e5e5ff':''?>>
			<TD width=30%><?php echo AjaxLink('album', $row->id_album, display_titrealbum($row))?></TD>
			<TD width=10></TD>
			<TD width=30%><?php echo AjaxLink('serie', $row->id_serie, display_titreserie($row), 'série')?></TD>
			<TD width=10></TD>
			<TD width=30%><?php echo ($row->moisparution > 0 ? $mois[$row->moisparution].' ':'').NonZero($row->anneeparution)?></TD>
            
		</TR>
<?php
	}
?>
	</TABLE>
</div>