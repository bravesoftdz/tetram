<?
include_once 'header.inc';
?>
<?
$albums = load_and_fetch('select count(*) as c from /*DB_PREFIX*/albums');
$editions = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editions');
$series = load_and_fetch('select count(*) as c from /*DB_PREFIX*/series');
$auteurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/personnes');
$editeurs = load_and_fetch('select count(*) as c from /*DB_PREFIX*/editeurs');
?>
<div id="outer">
	<div id="middle">
		<div id="inner">
			<TABLE cellpadding=0 cellspacing=0 border=0>
				<TR>
					<TD colspan=2>
						<FONT size=+4>BDThèque</FONT><br>
						<IMG src=graphics/acceuil.jpg border=0>
					</td>
				</tr>
				<tr>
					<td>
						<b><?echo $albums->c?></b> albums connus pour <b><?echo $editions->c?></b> albums dans la biliothèque,<br>
						répartis sur <b><?echo $series->c?></b> séries chez <b><?echo $editeurs->c?></b> éditeurs,<br>
						et réalisés par <b><?echo $auteurs->c?></b> auteurs.
					</td>
					<td valign=bottom align=right>
						<font size=1>Site généré par <a href=http://www.tetram.org/bdtheque target=_blank>BDthèque</a></font>
					</td>
				</TR>
			</TABLE>
		</div>
	</div>
</div>
