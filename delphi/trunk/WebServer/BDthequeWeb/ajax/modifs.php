<?php
include_once '../routines.php';
?>
<div class=entete>
	<H1>Dernières modifications</H1>
</div>
<div class=body>
	<TABLE border=0 width=100%>
<?php
$ajouts = load_sql("select *, cast(date_creation as date) = cast(date_modif as date) is_creation from /*DB_PREFIX*/vw_dernieres_modifs order by date_modif desc limit 0,30");

while ($ajout = $ajouts->fetch_object())
{
			?>
		<tr>
			<td>
			<?php
	echo $ajout->date_modif.' - ';
	switch ($ajout->typedata)
	{
		case 'A': 
		{
			echo AjaxLink('album', $ajout->id, display_titrealbum($ajout, false, true)).' (Album)';
			break;
		}
		case 'S':
		{
			echo AjaxLink('serie', $ajout->id, display_titreserie($ajout)).' (Série)';
			break;
		}
		case 'P':
		{
 			echo AjaxLink('personne', $ajout->id, format_titre($ajout->nompersonne), 'auteur').' (Auteur)';
			break;
		}
	}
	if ($ajout->is_creation == 1)
		echo '&nbsp;<img src=graphics/nouveau.gif>';
	echo '<br>';
			?>
			</td>
		</tr>
			<?php
}
?>
	</TABLE>
</div>
